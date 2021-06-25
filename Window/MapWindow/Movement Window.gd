extends WindowDialog
class_name MovementWindow

onready var tilemap : TileMap = $TileMap

func _init(max_range := 3, tile_map := $TileMap as TileMap, map := Map.new()):
	tilemap = tile_map

static func range_to_size(max_range : int, tile_map : TileMap) -> Vector2:
	return Vector2.ONE * ((max_range * 2) + 3) * tile_map.cell_size * tile_map.scale
