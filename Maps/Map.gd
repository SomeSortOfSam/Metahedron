extends Resource
class_name Map

# map size in tiles
export var size : Vector2
export var cell_size : Vector2

var _half_cell_size = cell_size / 2

func map_to_world_space(map_point : Vector2) -> Vector2 :
	return map_point * cell_size + _half_cell_size

func world_to_map_space(world_point : Vector2) -> Vector2 :
	return (world_point / cell_size).floor()

func is_within_bounds(map_point : Vector2) -> bool :
	return map_point.x >= 0 && map_point.x < size.x && map_point.y >= 0 && map_point.y < size.y

func clamp(map_point : Vector2) -> Vector2:
	map_point.x = clamp(map_point.x,0,size.x)
	map_point.y = clamp(map_point.y,0,size.y)
	return map_point

func map_to_map_index(map_point : Vector2) -> int :
	return int(map_point.x + size.x * map_point.y)
