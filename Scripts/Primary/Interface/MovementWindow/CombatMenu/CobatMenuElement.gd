extends Button
class_name CombatMenuElement

onready var _icon : TextureRect = $Body/HBoxContainer/AspectRatioContainer/Outline/Body/TextureRect
onready var _label : Label = $Body/HBoxContainer/RichTextLabel

var attack

signal attack_selected(attack)

func subscribe(new_attack : Attack):
	attack = new_attack
	_icon.texture = attack.icon
	_label.text = attack.name + "\n"
	_label.text += ": " + attack.description

func _on_CobatMenuElement_pressed():
	emit_signal("attack_selected",attack)
