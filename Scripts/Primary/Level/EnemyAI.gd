extends Node
class_name EnemyAI

var enemies := {}
var map : Map

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
		enemy.set_cell(cell + Vector2.DOWN)
		var astar = Pathfinder.refrence_map_to_astar(enemy.window.map)
		var path = astar.get_point_path(MapSpaceConverter.refrence_map_to_index(cell),MapSpaceConverter.refrence_map_to_index(cell + Vector2.DOWN))
		enemy.follow_path(path)
