extends Control
class_name CombatMenu

var elements := []

signal attack_selected(attack)

func _ready():
	for child in get_child(0).get_children():
		elements.append(child as CombatMenuElement)

func subscribe(person):
	var i := 0
	for attack in person.attacks:
		elements[i].subscribe(attack)
		i += 1

func _on_CobatMenuElement_attack_selected(attack):
	emit_signal("attack_selected",attack)
