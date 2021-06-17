extends Node2D
class_name GameBoard

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

export var map : Resource = preload("res://Maps/TestMap.tres")

var _units := {}
var _active_unit : Character
var _walkable_cells := []

onready var _tile_map : TileMap = $TileMap
onready var _unit_overlay : UnitOverlay = $YSort/UnitOverlay
onready var _unit_path : UnitPath = $YSort/UnitPath
onready var _y_sort : YSort = $YSort

func _ready():
	resize_map()
	_reinitialize()

func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

func resize_map():
	map.cell_size = _tile_map.cell_size * _tile_map.scale
	map.map_rect = _tile_map.get_used_rect()

func _reinitialize():
	_units.clear()
	
	for child in _y_sort.get_children():
		child.map = map
		var unit := child as Character
		if not unit:
			continue
		
		_units[unit.cell] = unit

func get_walkable_cells(unit : Character) -> Array:
	return _flood_fill(unit.cell, unit.map_speed)

func _flood_fill(cell : Vector2, max_distance : int) -> Array:
	var out := []
	var stack := [cell]
	
	while not stack.empty():
		var current = stack.pop_back()
		
		if not map.is_within_bounds(current) or current in out:
			continue
		
		var diffrence : Vector2 = (current - cell).abs()
		var distance := int(diffrence.x + diffrence.y)
		if distance > max_distance:
			continue
		
		out.append(current)
		
		for direction in DIRECTIONS:
			var coordinates: Vector2 = current + direction
			if is_occupied(coordinates) or coordinates in out or _tile_map.get_cellv(coordinates + map.map_rect.position) == -1 :
				continue
			
			stack.append(coordinates)
	
	return out

func _select_unit(cell : Vector2):
	if not _units.has(cell):
		return
	
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	_walkable_cells = get_walkable_cells(_active_unit)
	_unit_overlay.draw(_walkable_cells)
	_unit_path.initialize(_walkable_cells)

func _deselect_active_unit():
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()

func _clear_active_unit():
	_active_unit = null
	_walkable_cells.clear()

func _move_active_unit(new_cell: Vector2):
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	
	_deselect_active_unit()
	
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit,"walk_finished")
	_clear_active_unit()

func _on_Cursor_accept_pressed(cell):
	if not _active_unit:
		_select_unit(cell)
	elif _active_unit.is_selected:
		_move_active_unit(cell)

func _on_Cursor_moved(new_cell):
	if _active_unit and _active_unit.is_selected:
		_unit_path.draw(_active_unit.cell, new_cell)

func _unhandled_input(event : InputEvent):
		if _active_unit and event.is_action_pressed("ui_cancel"):
			_deselect_active_unit()
			_clear_active_unit()
