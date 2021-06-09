extends Node2D

export var map : Resource = preload("res://Maps/TestMap.tres")

onready var _tile_map : TileMap = $TileMap
onready var _character : Character = $Character

func _ready():
	map.size = _tile_map.get_used_rect().size / _tile_map.cell_size
	map.cell_size = _tile_map.cell_size
	var array : PoolVector2Array = []
	for cell in _tile_map.get_used_cells():
		array.append(map.world_to_map_space(cell))
	_character.walk_along(array)
