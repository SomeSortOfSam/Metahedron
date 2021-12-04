extends Button
class_name CombatMenuElement

onready var _icon : TextureRect = $Body/HBoxContainer/AspectRatioContainer/Outline/Body/TextureRect
onready var _name : Label = $Body/HBoxContainer/AspectRatioContainer/Outline/Name
onready var _description : Label = $Body/HBoxContainer/Control/Description
onready var _damage : Label = $Body/HBoxContainer/Control/Control/Amount
onready var _friendly : TextureRect = $Body/HBoxContainer/Control/Control/Friendly

var attack

signal attack_selected(attack)

func subscribe(new_attack : Attack):
	attack = new_attack
	_icon.texture = attack.icon
	_name.text = attack.name + ":"
	_description.text = attack.description
	_damage.text = str(attack.damage)
	_friendly.visible = !attack.friendlyFire

func _on_CobatMenuElement_pressed():
	emit_signal("attack_selected",attack)
