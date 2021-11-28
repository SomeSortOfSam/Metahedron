extends BaseButton
class_name PlayerUnitGUI
## Displays the state of a unit in the players control

onready var portrait : TextureRect = $Body/HBoxContainer/Control/Control/Portrait
onready var icon : TextureRect = $Body/Icon
onready var label : Label = $Body/HBoxContainer/Label

onready var moved : TextureRect = $AspectRatioContainer/EndTurn/Control2/Moved
onready var attacked : TextureRect = $AspectRatioContainer/EndTurn/Control2/Attacked
onready var outline : ColorRect = $Outline
onready var body : ColorRect = $Body/BodyColor

export var new_turn_outline_color : Color
export var has_moved_outline_color : Color

export var new_turn_body_color : Color
export var has_set_end_turn_body_color : Color
export var has_attacked_body_color : Color

signal request_end_turn()

func subscribe(person : Person):
	call_deferred("_on_person_new_turn", person)
	populate_textures(person)
	var _connection = connect("request_end_turn",person,"_on_PlayerUnitGUI_requesting_end_turn")
	_connection = connect("pressed", person, "open_window")
	_connection = person.connect("move",self,"_on_person_move")
	_connection = person.connect("end_turn",self,"_on_person_end_turn")
	_connection = person.connect("attack",self,"_on_person_attack")
	_connection = person.connect("new_turn",self,"_on_person_new_turn",[person],CONNECT_DEFERRED)
	_connection = person.connect("died", self, "_on_person_died")
	_connection = person.connect("hurt", self, "_on_person_hurt", [person])

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

func _on_person_new_turn(person):
	portrait.texture = person.character.animations.get_frame("Idle",0)
	outline.color = new_turn_outline_color
	body.color = new_turn_body_color
	attacked.modulate = Color.red
	moved.modulate = Color.yellow

func _on_person_hurt(person):
	portrait.texture = person.character.animations.get_frame("Hurt",0)

func _on_person_died():
	queue_free()

func _on_EndTurn_pressed():
	emit_signal("request_end_turn")

func _on_PlayerUnitGUI_button_down():
	body.color.v += .05

func _on_PlayerUnitGUI_button_up():
	body.color.v -= .05

func _on_PlayerUnitGUI_focus_entered():
	outline.color.v += .05

func _on_PlayerUnitGUI_focus_exited():
	outline.color.v -= .05
