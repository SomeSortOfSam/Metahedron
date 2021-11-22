extends Reference
class_name TurnManager
## Thing what handles the turn order

var evil_turn := false
var turns := 0 setget set_turns

signal turn_ended(next_player)
signal new_turns(text,new_turns)

func subscribe(map : Map):
	for person in map.people.values():
		_on_map_person_added(person)
	var _connection = map.connect("person_added",self,"_on_map_person_added")

func set_turns(new_turns):
	turns = new_turns
	emit_signal("new_turns","text",str(new_turns))
	if turns <= 0:
		evil_turn = !evil_turn
		emit_signal("turn_ended",evil_turn)

func _on_map_person_added(person : Person):
	turns += 1 if person.is_evil == evil_turn else 0
	var _connection

	_connection = person.connect("attack",self,"_on_person_attack")
	_connection = person.connect("skip_turn",self,"_on_person_end_turn")

	_connection = person.connect("unskip_turn",self,"_on_person_unend_turn")
	_connection = person.connect("new_turn", self, "_on_person_unend_turn")

	_connection = connect("turn_ended", person, "reset_turn")

func _on_person_attack(_direction):
	self.turns -= 1

func _on_person_end_turn():
	self.turns -= 1

func _on_person_unend_turn():
	self.turns += 1
