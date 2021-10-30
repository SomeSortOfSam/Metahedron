extends Node
class_name EnemyAI

var enemies := {} setget ,get_enemies
var map : Map

func _init(new_map : Map):
	map = new_map

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()

func get_enemies() -> Dictionary:
	enemies.clear()
	for cell in map.people:
		if map.people[cell].is_evil:
			enemies[cell] = map.people[cell]
	return enemies

func start_enemy_turn():
	for cell in enemies:
		var enemy : Person = enemies[cell]
		enemy.cell += Vector2.DOWN
		enemy.set_skipped(true)
		
