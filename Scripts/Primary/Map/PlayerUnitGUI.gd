extends Control

var person : Person

func subscribe(new_person : Person):
	person = new_person


func _on_EndTurn_pressed():
	person.has_set_end_turn = true
