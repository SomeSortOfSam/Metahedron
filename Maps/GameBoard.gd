extends Node2D
class_name GameBoard

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

export var map : Resource = preload("res://Maps/TestMap.tres")

var _units := {}

onready var _tile_map : TileMap = $TileMap
onready var _unit_overlay : UnitOverlay = $YSort/UnitOverlay
onready var _y_sort : YSort = $YSort

func _ready():
	resize_map()
	_reinitialize()

func is_occupied(cell: Vector2) -> bool:
	return true if _units.has(cell) else false

func resize_map():
	var size := _tile_map.get_used_rect().size
	map.cell_size = _tile_map.cell_size * _tile_map.scale
	size -= Vector2.ONE
	map.size = size

func _reinitialize():
	_units.clear()
	
	for child in _y_sort.get_children():
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
			if is_occupied(coordinates) or coordinates in out or _tile_map.get_cellv(coordinates) == -1 :
				continue
			
			stack.append(coordinates)
	
	return out
