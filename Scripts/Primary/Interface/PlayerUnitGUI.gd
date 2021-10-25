extends Control

onready var portait : TextureRect = $Body/HBoxContainer/Control/Control/Portrait
onready var icon : TextureRect = $Body/Icon
onready var label : Label = $Body/HBoxContainer/Label

onready var end_turn : TextureButton = $AspectRatioContainer/EndTurn
onready var outline : ColorRect = $Outline
onready var body : ColorRect = $Body

export var new_turn_outline_color : Color
export var has_moved_outline_color : Color

export var new_turn_body_color : Color
export var has_set_end_turn_body_color : Color
export var has_attacked_body_color : Color

signal request_end_turn()

func _ready():
	_on_new_turn()

func subscribe(person : Person):
	populate_texture(person)
	var _connection = connect("request_end_turn",person,"set",["has_set_end_turn",true])
	_connection = person.connect("lock_window",self,"_on_lock_window")
	_connection = person.connect("has_set_end_turn",self,"_on_has_set_end_turn")
	_connection = person.connect("has_attacked",self,"_on_has_attacked")
	_connection = person.connect("new_turn",self,"_on_new_turn")

func populate_texture(person : Person):
	portait.texture = person.character.animations.get_frame("Idle",0)
	icon.texture = person.character.level_texture
	label.text = person.character.name

func _on_has_attacked():
	outline.color = has_moved_outline_color
	body.color = has_attacked_body_color

func _on_has_set_end_turn(new_end_turn):
	body.color = has_set_end_turn_body_color if new_end_turn else new_turn_body_color

func _on_new_turn():
	end_turn.show()
	outline.color = new_turn_outline_color
	body.color = new_turn_body_color

func _on_lock_window():
	outline.color = has_moved_outline_color

func _on_EndTurn_pressed():
	emit_signal("request_end_turn")
