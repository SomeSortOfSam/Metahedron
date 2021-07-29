extends Map
class_name ReferenceMap

var map : Map
var rect : Rect2

func _init(new_tile_map : TileMap, new_map : Map, center_cell : Vector2, tile_range : int).(new_tile_map):
	map = new_map
	rect = range_to_rect(center_cell,tile_range)

func is_walkable(map_point: Vector2) -> bool:
	return map.is_walkable(map_to_internal_map(map_point))

func internal_map_to_map(internal_map_point : Vector2) -> Vector2:
	return internal_map_point + rect.position

func map_to_internal_map(map_point : Vector2) -> Vector2:
	return map_point - rect.position

func range_to_rect(center_cell : Vector2, tile_range : int) -> Rect2:
	var position := center_cell - Vector2.ONE * tile_range
	var size := Vector2.ONE * ((tile_range * 2) + 1)
	return Rect2(position, size)
