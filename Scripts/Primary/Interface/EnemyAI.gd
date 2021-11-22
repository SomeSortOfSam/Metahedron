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

func get_all_adjacent_cells(cell : Vector2) -> Array:
	var cells = [cell + Vector2.UP, cell + Vector2.RIGHT, cell + Vector2.LEFT, cell + Vector2.DOWN]
	return cells

#Returns the number of player controlled units in the same column as cell
func get_num_friendlies_in_column(cell : Vector2) -> int:
	var friendlies = get_friendly_units()
	var count := 0
	for friendly_cell in friendlies:
		if friendly_cell.x == cell.x:
			count += 1
		print(friendlies[friendly_cell].cell == friendly_cell)
	return count

#Returns the number of player controlled units in the same row as cell
func get_num_friendlies_in_row(cell : Vector2) -> int:
	var friendlies = get_friendly_units()
	var count := 0
	for friendly_cell in friendlies:
		if friendly_cell.y == cell.y:
			count += 1
	return count

func determine_cell_score(cell : Vector2) -> int:
	var score := 0
	score += get_num_friendlies_in_column(cell) + get_num_friendlies_in_row(cell)
	return score

func get_all_cells_in_range(person : Person) -> Array:
	return Pathfinder.get_walkable_tiles_in_range(person.window.map,[])

func start_enemy_turn():
	var enemies = get_enemies()
	for cell in enemies:
		var enemy : Person = enemies[cell]
		
		var target_cells = get_all_cells_in_range(enemy)
		
		var cell_scores = [0, 0, 0, 0]
		var current_cell_index := 0
		var max_score_index := -1
		
		for target in target_cells:
			cell_scores.append(determine_cell_score(target))
			if cell_scores[current_cell_index] > cell_scores[max_score_index]:
				max_score_index = current_cell_index
			current_cell_index += 1
		
		var target_cell = target_cells[max_score_index]
		var delta_cell : Vector2 = target_cell - cell
		enemy.cell += delta_cell
		enemy.set_skipped(true)

