extends Control
class_name PlayerUnitGUI
## Displays the state of a unit in the players control

onready var portrait : TextureRect = $Body/HBoxContainer/Control/Control/Portrait
onready var icon : TextureRect = $Body/Icon
onready var label : Label = $Body/HBoxContainer/Label

onready var moved : TextureRect = $AspectRatioContainer/EndTurn/Control2/Moved
onready var attacked : TextureRect = $AspectRatioContainer/EndTurn/Control2/Attacked
onready var outline : ColorRect = $Outline
onready var body : ColorRect = $Body

export var new_turn_outline_color : Color
export var has_moved_outline_color : Color

export var new_turn_body_color : Color
export var has_set_end_turn_body_color : Color
export var has_attacked_body_color : Color

signal request_end_turn()

func _ready():
	_on_person_new_turn()

func subscribe(person : Person):
	populate_textures(person)
	var _connection = connect("request_end_turn",person,"_on_PlayerUnitGUI_requesting_end_turn")
	_connection = person.connect("move",self,"_on_person_move")
	_connection = person.connect("end_turn",self,"_on_person_end_turn")
	_connection = person.connect("attack",self,"_on_person_attack")
	_connection = person.connect("new_turn",self,"_on_person_new_turn",[],CONNECT_DEFERRED)
	_connection = person.connect("died", self, "_on_person_died")

func populate_textures(person : Person):
	portrait.texture = person.character.animations.get_frame("Idle",0)
	icon.texture = person.character.level_texture
	label.text = person.character.name

func _on_person_move(_delta):
	outline.color = has_moved_outline_color
	moved.modulate = has_attacked_body_color

func _on_person_attack(_direction,_attack):
	attacked.modulate = has_attacked_body_color

func _on_person_end_turn():
	body.color = has_set_end_turn_body_color

func _on_person_new_turn():
	outline.color = new_turn_outline_color
	body.color = new_turn_body_color
	attacked.modulate = Color.red
	moved.modulate = Color.yellow

func _on_person_died():
	queue_free()

func _on_EndTurn_pressed():
	emit_signal("request_end_turn")
