extends Node
class_name EnemyAI

var map : Map

func _init(new_map : Map):
	map = new_map

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()

func get_enemies() -> Dictionary:
	var enemies := {}
	for cell in map.people:
		if map.people[cell].is_evil:
			enemies[cell] = map.people[cell]
	return enemies

func start_enemy_turn():
	var enemies = get_enemies()
	for cell in enemies:
		var enemy : Person = enemies[cell]
		enemy.cell += Vector2.DOWN
		enemy.set_skipped(true)
		
