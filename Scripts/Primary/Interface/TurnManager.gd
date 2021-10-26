extends Reference
class_name TurnManager

var num_units_with_turn := 0 setget set_num_turns
var evil_turn := false

signal turn_ended(evil_turn)

func set_num_turns(new_num_turns):
	num_units_with_turn = new_num_turns
	if num_units_with_turn <= 0:
		evil_turn = !evil_turn
		emit_signal("turn_ended",evil_turn)

func subscribe(map : Map):
	for person in map.people.values():
		_on_map_person_added(person)
	var _connection = map.connect("person_added",self,"_on_map_person_added")

func _on_map_person_added(person):
	var _connection = person.connect("new_turn",self,"_on_person_new_turn")
	_connection = person.connect("has_set_end_turn",self,"_on_person_has_set_end_turn")
	_connection = connect("turn_ended",person,"reset_turn")

func _on_person_new_turn():
	self.num_units_with_turn += 1

func _on_person_has_set_end_turn(ending_turn):
	self.num_units_with_turn -= 1 if ending_turn else -1 
