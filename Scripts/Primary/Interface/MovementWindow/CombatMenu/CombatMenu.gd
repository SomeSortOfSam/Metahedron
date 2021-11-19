extends Control
class_name CombatMenu

onready var timer : Timer = $Timer
var elements := []

signal attack_selected(attack)
signal requesting_close()

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

func _on_visibility_changed():
	if is_visible_in_tree():
		timer.start()

func _on_mouse_exited():
	timer.start()

func _on_mouse_entered():
	timer.stop()

func _on_Timer_timeout():
	emit_signal("requesting_close")
