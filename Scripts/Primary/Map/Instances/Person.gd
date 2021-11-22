extends Reference
class_name Person, "res://Assets/Editor Icons/Person.png"
## The where and what of a unit

var character : Character
var cell : Vector2 setget set_cell
var window : MovementWindow

var is_evil := false

var has_moved := false
var has_attacked := false
var has_skipped := false setget set_skipped

signal move(cell_delta)
signal attack(direction)
signal close_window()
signal open_window()
signal skip_turn()
signal unskip_turn()

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
		has_skipped = false
		emit_signal("new_turn")

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.call_deferred("subscribe",self)
	return window

func to_unit(map, icon) -> Unit:
	var unit : Unit = preload("res://Scripts/Primary/Displays/Unit.tscn").instance()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	return unit

func _on_window_requesting_close():
	emit_signal("close_window")
	set_skipped(false)


func open_window():
	emit_signal("open_window")
	set_skipped(false)

func set_skipped(new_end_turn : bool):
	if has_skipped != new_end_turn:
		has_skipped = new_end_turn
		if new_end_turn:
			emit_signal("skip_turn")
		else:
			emit_signal("unskip_turn")
