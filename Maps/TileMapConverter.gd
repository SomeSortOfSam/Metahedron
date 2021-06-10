extends Node2D

export var map : Resource = preload("res://Maps/TestMap.tres")

onready var _tile_map : TileMap = $TileMap
onready var _character : Character = $Character

func _ready():
	map.cell_size = _tile_map.cell_size * _tile_map.scale
	map.size = _tile_map.get_used_rect().size
