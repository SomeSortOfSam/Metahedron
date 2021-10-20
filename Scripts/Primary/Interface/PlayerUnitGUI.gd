extends Control

onready var portait : TextureRect = $Body/HBoxContainer/Control/Control/Portrait
onready var icon : TextureRect = $Body/Icon
onready var label : Label = $Body/HBoxContainer/Label
onready var end_turn : Button = $Body/HBoxContainer/EndTurn

signal request_end_turn()

func subscribe(person : Person):
	portait.texture = person.character.animations.get_frame("Idle",0)
	icon.texture = person.character.level_texture
	label.text = person.character.name
	var _connection = connect("request_end_turn",person,"set",["has_set_end_turn",true])
	_connection = person.connect("has_attacked",end_turn,"hide")
	_connection = person.connect("new_turn",end_turn,"show")


func _on_EndTurn_pressed():
	emit_signal("request_end_turn")
