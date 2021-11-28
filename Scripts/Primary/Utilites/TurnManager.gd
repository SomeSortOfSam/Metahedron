extends Reference
class_name TurnManager
## Thing what handles the turn order

var evil_turn := false
var turns := 0 setget set_turns

var map : Map

signal new_turn(evil_turn)

signal game_won()
signal game_lost()

func subscribe(new_map : Map):
	map = new_map
	for person in map.people.values():
		_on_map_person_added(person)
	var _connection = map.connect("person_added",self,"_on_map_person_added")

func set_turns(new_turns):
	turns = new_turns
	if turns <= 0:
		call_deferred("on_turn_ended")

func on_turn_ended():
	evil_turn = !evil_turn
	for person in map.people.values():
		if person.is_evil == evil_turn:
			add_person_to_turn(person)
	check_win()
	emit_signal("new_turn", evil_turn)

func add_person_to_turn(person : Person):
	turns += 1
	person.reset_turn()
	var _connection = person.connect("end_turn", self, "_on_person_end_turn", [person], CONNECT_ONESHOT)
	_connection = person.connect("died", self, "_on_person_end_turn", [person], CONNECT_ONESHOT)

func check_win():
	if turns == 0:
		if evil_turn:
			emit_signal("game_won")
		else:
			emit_signal("game_lost")

func _on_map_person_added(person : Person):
	if person.is_evil == evil_turn:
		add_person_to_turn(person)

func _on_person_end_turn(person : Person):
	self.turns -= 1
	person.disconnect("died", self, "_on_person_end_turn")

func _on_person_died(person : Person):
	self.turns -= 1
	person.disconnect("end_turn", self, "_on_person_end_turn")
