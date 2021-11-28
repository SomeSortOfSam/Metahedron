extends Reference
class_name Person, "res://Assets/Editor Icons/Person.png"
## The where and what of a unit

var character : Character
var attacks := [Attack.new(),DirectionalAttack.new(),HitscanAttack.new()]
var is_evil := false

var has_moved := false
var has_attacked := false

var cell : Vector2 setget set_cell
var health := 3
var window : MovementWindow

signal move(cell_delta)
signal attack(direction, attack)

signal hurt()
signal died()

signal close_window()
signal open_window()

signal new_turn()
signal end_turn()

func _init(new_character : Character, new_is_evil := false, new_cell := Vector2.ZERO):
	character = new_character
	is_evil = new_is_evil
	cell = new_cell

func set_cell(new_cell : Vector2):
	if !has_moved:
		var delta = new_cell - cell
		cell = new_cell
		has_moved = true
		emit_signal("move",delta)

func set_health(new_health : int):
	health = new_health
	if health >= 0:
		emit_signal("hurt")
	if health == 0:
		emit_signal("died")
		free()

func attack(attack : Attack, direction : Vector2):
	if !has_attacked:
		has_attacked = true
		emit_signal("attack",direction,attack)

func calculate_damage(attack : Attack, direction : Vector2, source : Person, map):
	if source.is_evil != is_evil || attack.friendlyFire:
		var damaged_cells := attack.attack(map,source.cell,direction)
		for damaged_cell in damaged_cells:
			if cell == damaged_cell:
				set_health(health - 1)

func reset_turn(evil_turn):
	if evil_turn == is_evil:
		has_moved = false
		has_attacked = false
		emit_signal("new_turn")

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.call_deferred("subscribe",self)
	return window

func open_window():
	emit_signal("open_window")

func to_unit(map, is_icon : bool) -> Unit:
	var unit : Unit = preload("res://Scripts/Primary/Displays/Unit.tscn").instance()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = is_icon
	return unit

func _on_window_requesting_close():
	emit_signal("close_window")

func _on_PlayerUnitGUI_requesting_end_turn():
	emit_signal("end_turn")

