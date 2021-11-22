extends Reference
class_name Person, "res://Assets/Editor Icons/Person.png"
## The where and what of a unit

var character : Character
var cell : Vector2 setget set_cell
var window : MovementWindow

var attacks := [Attack.new(),DirectionalAttack.new(),HitscanAttack.new()]

var is_evil := false

var has_moved := false
var has_attacked := false

signal move(cell_delta)

signal attack_selected(attack)
signal attack(direction, attack)

signal close_window()
signal open_window()

signal end_turn()

signal new_turn()

func _init(new_character : Character, new_is_evil := false, new_cell := Vector2.ZERO):
	character = new_character
	is_evil = new_is_evil
	cell = new_cell

func set_cell(new_cell : Vector2):
	var old_cell = cell
	cell = new_cell
	has_moved = true
	emit_signal("move",new_cell - old_cell)

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

func to_unit(map, icon) -> Unit:
	var unit : Unit = preload("res://Scripts/Primary/Displays/Unit.tscn").instance()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	return unit

func _on_window_requesting_close():
	emit_signal("close_window")

func _on_PlayerUnitGUI_requesting_end_turn():
	emit_signal("end_turn")

