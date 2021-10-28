extends Node
class_name EnemyAI

var enemies := {}
var map : Map

signal enemy_turn_ended()

func _init(new_map : Map):
	var map = new_map
	var people = map.people
	for cell in people:
		if people[cell].is_evil:
			enemies[cell] = people[cell]
			print(cell)

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()
		
func start_enemy_turn():
	print("Enemy Turn Started >:)")
	for cell in enemies:
		var enemy = enemies[cell]
		print("I'm sure the enemy would have moved here")
	end_enemy_turn()
		
func end_enemy_turn():
	print("Enemy Turn Ended")
	emit_signal("enemy_turn_ended")
