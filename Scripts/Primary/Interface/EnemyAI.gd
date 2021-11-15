extends Node
class_name EnemyAI

var map : Map

func _init(new_map : Map):
	map = new_map

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()

func get_enemies() -> Dictionary:
	var enemies : Dictionary
	for cell in map.people:
		if map.people[cell].is_evil:
			enemies[cell] = map.people[cell]
	return enemies

func get_friendly_units() -> Dictionary:
	var people : Dictionary
	for cell in map.people:
		if !map.people[cell].is_evil:
			people[cell] = map.people[cell] 
	return people

#Gets the closest friendly (player controlled) unit to the specified cell
func get_closest_friendly(cell : Vector2) -> Vector2:
	var people = get_friendly_units()
	var minimum_distance := -1
	var closest_cell : Vector2
	for friendly_cell in people:
		var x_dist = friendly_cell.x - cell.x
		var y_dist = friendly_cell.y - cell.y
		var distance = sqrt(pow(x_dist, 2) + pow(y_dist, 2))
		if(minimum_distance == -1):
			minimum_distance = distance
			closest_cell = friendly_cell
		if(distance < minimum_distance):
			minimum_distance = distance
			closest_cell = friendly_cell
	return closest_cell

#Returns the closest cell from origin_cell adjacent to target_cell
func get_closest_adjacent_cell(origin_cell : Vector2, target_cell : Vector2) -> Vector2:
	var x_dist = target_cell.x - origin_cell.x
	var y_dist = target_cell.y - origin_cell.y
	if(abs(x_dist) > abs(y_dist)):
		if(x_dist < 0):
			target_cell.x += 1
		else:
			target_cell.x -= 1
	else:
		if(y_dist < 0):
			target_cell.y += 1
		else:
			target_cell.y -= 1
	return target_cell

func start_enemy_turn():
	var enemies = get_enemies()
	for cell in enemies:
		var enemy : Person = enemies[cell]
		var closest_friendly_cell = get_closest_friendly(cell)
		var target_cell = get_closest_adjacent_cell(cell, closest_friendly_cell)
		var delta_cell : Vector2 = target_cell - cell
		enemy.cell += delta_cell
		enemy.set_skipped(true)

