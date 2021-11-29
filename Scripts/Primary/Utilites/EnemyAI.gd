extends Reference
class_name EnemyAI

var map : Map
var attacks := [Attack.new(),DirectionalAttack.new(),HitscanAttack.new()]

func _init(new_map : Map):
	map = new_map

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()

func start_enemy_turn():
	for enemy in get_enemies():
		move_enemy(enemy)
		decide_attack(enemy)
		enemy.emit_signal("end_turn")

func move_enemy(enemy : Person):
	var best_cell = get_best_cell(enemy)
	if enemy.cell != best_cell:
		enemy.open_window()
		enemy.cell = best_cell

func decide_attack(enemy : Person):
	var closest_friendly := get_closest_friendly(enemy.cell, get_friendly_units())
	if closest_friendly.x == enemy.cell.x || closest_friendly.y == enemy.cell.y:
		if abs(closest_friendly.x - enemy.cell.x) > 1 || abs(closest_friendly.y - enemy.cell.y) > 1:
			enemy.attack(attacks[2], get_direction_between_cells(enemy.cell, closest_friendly))
		else:
			enemy.attack(attacks[0], get_direction_between_cells(enemy.cell, closest_friendly))

func get_direction_between_cells(cell_one : Vector2, cell_two : Vector2) -> Vector2:
	if cell_one.x == cell_two.x:
		if cell_one.y > cell_two.y:
			return Vector2.DOWN
		elif cell_one.y < cell_two.y:
			return Vector2.UP
	elif cell_one.y == cell_two.y:
		if cell_one.x > cell_two.x:
			return Vector2.LEFT
		elif cell_one.x < cell_two.x:
			return Vector2.RIGHT
	return Vector2.ZERO

func get_enemies() -> Array:
	var enemies := []
	for person in map.people.values():
		if person.is_evil:
			enemies.append(person)
	return enemies

func get_best_cell(enemy : Person) -> Vector2:
	var target_cells = Pathfinder.get_walkable_tiles_in_range(enemy.window.map)
	
	var i = 0
	while i < target_cells.size():
		if Pathfinder.is_occupied(target_cells[i],map):
			target_cells.remove(i)
			i -= 1
		i += 1
	target_cells.push_front(enemy.cell)
	
	var cell_scores = []
	var max_score_index := 0
	
	for index in target_cells.size():
		var score := determine_cell_score(target_cells[index])
		cell_scores.append(score)
		if cell_scores[index] > cell_scores[max_score_index]:
			max_score_index = index
	
	return target_cells[max_score_index]

func determine_cell_score(cell : Vector2) -> float:
	var score := 0.0
	var friendlies := get_friendly_units()
	var closest_friendly_cell := get_closest_friendly(cell, friendlies)
	score -= abs(cell.x - closest_friendly_cell.x)
	score -= abs(cell.y - closest_friendly_cell.y)
	return score

func get_friendly_units() -> Array:
	var people := []
	for person in map.people.values():
		if !person.is_evil:
			people.append(person) 
	return people

func get_closest_friendly(cell : Vector2, friendlies : Array) -> Vector2:
	var minimum_distance := -1
	var closest_cell : Vector2
	for friend in friendlies:
		var x_dist = friend.cell.x - cell.x
		var y_dist = friend.cell.y - cell.y
		var distance = pow(x_dist, 2) + pow(y_dist, 2)
		if(minimum_distance == -1 || distance < minimum_distance):
			minimum_distance = distance
			closest_cell = friend.cell
	return closest_cell
