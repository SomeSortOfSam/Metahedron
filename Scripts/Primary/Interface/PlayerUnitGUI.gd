extends Control

onready var portait : TextureRect = $Body/HBoxContainer/Control/Control/Portrait
onready var icon : TextureRect = $Body/Icon
onready var label : Label = $Body/HBoxContainer/Label

onready var end_turn : TextureButton = $AspectRatioContainer/EndTurn
onready var moved : TextureRect = $AspectRatioContainer/EndTurn/Control2/Moved
onready var attacked : TextureRect = $AspectRatioContainer/EndTurn/Control2/Attacked
onready var outline : ColorRect = $Outline
onready var body : ColorRect = $Body

export var new_turn_outline_color : Color
export var has_moved_outline_color : Color

export var new_turn_body_color : Color
export var has_set_end_turn_body_color : Color
export var has_attacked_body_color : Color

signal request_skip_turn()

func _ready():
	_on_person_new_turn()

func subscribe(person : Person):
	populate_textures(person)
	var _connection = connect("request_skip_turn",person,"set_skipped",[true])
	_connection = person.connect("move",self,"_on_person_move")
	_connection = person.connect("skip_turn",self,"_on_person_skip_turn")
	_connection = person.connect("attack",self,"_on_person_attack")
	_connection = person.connect("new_turn",self,"_on_person_new_turn")

func populate_textures(person : Person):
	portait.texture = person.character.animations.get_frame("Idle",0)
	icon.texture = person.character.level_texture
	label.text = person.character.name

func _on_person_attack():
	outline.color = has_moved_outline_color
	body.color = has_attacked_body_color
	attacked.modulate = has_attacked_body_color

func _on_person_skip_turn(new_end_turn):
	body.color = has_set_end_turn_body_color if new_end_turn else new_turn_body_color

func _on_person_new_turn():
	end_turn.show()
	outline.color = new_turn_outline_color
	body.color = new_turn_body_color
	attacked.modulate = Color.red
	moved.modulate = Color.yellow

func _on_person_move(_delta):
	outline.color = has_moved_outline_color
	moved.modulate = has_attacked_body_color

func _on_EndTurn_pressed():
	emit_signal("request_skip_turn")
