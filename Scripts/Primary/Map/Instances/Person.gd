extends Reference
class_name Person

var character : Character
var cell : Vector2 setget set_cell
var window : MovementWindow setget ,get_movement_window

var is_evil := false

var has_moved := false
var has_attacked := false
var has_set_end_turn := false setget set_end_turn

signal cell_change(delta)
signal requesting_follow_path(path)
signal lock_window()
signal has_set_end_turn(is_true)
signal has_attacked()
signal new_turn()

func _init(new_character : Character, new_is_evil := false, new_cell := Vector2.ZERO):
	character = new_character
	is_evil = new_is_evil
	cell = new_cell

func set_cell(new_cell : Vector2):
	var old_cell = cell
	cell = new_cell
	emit_signal("cell_change",new_cell - old_cell)

func reset_turn(evil_turn):
	if evil_turn == is_evil:
		has_moved = false
		has_attacked = false
		has_set_end_turn = false
		emit_signal("new_turn")
		if is_evil:
			self.has_set_end_turn = true

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.call_deferred("subscribe",self)
	return window

func get_movement_window() -> MovementWindow:
	self.has_set_end_turn = false
	return window

func to_unit(map, icon) -> Unit:
	var unit : Unit = preload("res://Scripts/Primary/Map/Displays/Unit.tscn").instance()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	return unit

func _on_path_accepted(path : PoolVector2Array):
	if !has_attacked && !has_moved:
		var offset = path[path.size() - 1]
		cell += offset
		emit_signal("cell_change", offset)
		emit_signal("requesting_follow_path",path)
		has_moved = true
		emit_signal("lock_window")

func _on_window_closed():
	self.has_set_end_turn = true

func set_end_turn(new_end_turn):
	if has_set_end_turn != new_end_turn:
		has_set_end_turn = new_end_turn
		emit_signal("has_set_end_turn",has_set_end_turn)

func set_attacked(new_attacked):
	has_attacked = new_attacked
	emit_signal("has_attacked")
