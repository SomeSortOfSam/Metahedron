extends Reference
class_name EnemyAI

var map : Map

func _init(new_map : Map):
	map = new_map

func check_turn(evil_turn):
	if evil_turn:
		start_enemy_turn()

func start_enemy_turn():
	var moved := false
	for enemy in get_enemies():
		moved = moved or move_enemy(enemy)
	var timer = Timer.new()
	var _connection = timer.connect("timeout",self,"_on_move_phase_ended",[timer],CONNECT_ONESHOT)
	map.tile_map.get_tree().current_scene.add_child(timer)
	timer.start(1.5 if moved else .2)

func _on_move_phase_ended(timer : Timer):
	var attacked := false
	for enemy in get_enemies():
		attacked = attacked or decide_attack(enemy)
	var _connection = timer.connect("timeout",self,"_on_attack_phase_ended",[timer],CONNECT_ONESHOT)
	timer.start(1.5 if attacked else .2)

func _on_attack_phase_ended(timer: Timer):
	for enemy in get_enemies():
		enemy.emit_signal("end_turn")
	timer.queue_free()

func move_enemy(enemy : Person) -> bool:
	var best_cell = get_best_cell(enemy)
	if enemy.cell != best_cell:
		enemy.open_window()
		enemy.cell = best_cell
		return true
	return false

func decide_attack(enemy : Person) -> bool:
	var best_attack : Attack = null
	var best_attacked_amount := 0
	var best_direction := Vector2.ZERO
	for attack in enemy.attacks:
		for direction in AttackRenderer.DIRECTIONS:
			var attacked_amount := 0
			for cell in attack.attack(map, enemy.cell, direction):
				if Pathfinder.is_occupied(cell,map) && !map.people[cell].is_evil:
					attacked_amount += 1
			if attacked_amount > best_attacked_amount:
				best_attack = attack
				best_direction = direction
				best_attacked_amount = attacked_amount
	if best_attack:
		enemy.attack(best_attack,best_direction)
		return true
	return false

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
