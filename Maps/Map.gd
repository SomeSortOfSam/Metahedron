extends Resource
class_name Map

signal map_rect_changed

# map size in tiles
export var map_rect : Rect2 setget set_map_rect
export var cell_size : Vector2

func set_map_rect(new_map_rect : Rect2):
	map_rect = new_map_rect
	emit_signal("map_rect_changed")

func map_to_world_space(map_point : Vector2) -> Vector2 :
	return (map_point + map_rect.position) * cell_size + (cell_size/2) 

func world_to_map_space(world_point : Vector2) -> Vector2 :
	return (world_point / cell_size).floor() - map_rect.position

func is_within_bounds(map_point : Vector2) -> bool :
	var bounded_x : bool = map_point.x >= 0 && map_point.x <= map_rect.size.x
	var bounded_y : bool = map_point.y >= 0 && map_point.y <= map_rect.size.y
	return bounded_x && bounded_y 

func clamp(map_point : Vector2) -> Vector2:
	map_point.x = clamp(map_point.x,0,map_rect.size.x)
	map_point.y = clamp(map_point.y,0,map_rect.size.y)
	return map_point

func map_to_map_index(map_point : Vector2) -> int :
	return int(map_point.x + map_rect.size.x * map_point.y)
