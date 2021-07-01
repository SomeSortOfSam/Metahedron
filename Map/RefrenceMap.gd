extends Map
class_name RefrenceMap

var refrence_map : Map
var refrence_rect : Rect2

func _init(new_map := Map.new(), new_rect := Rect2(Vector2.ZERO,Vector2.ZERO)):
	refrence_map = new_map
	refrence_rect = new_rect

func is_walkable(map_point: Vector2) -> bool:
	return refrence_map.is_walkable(map_to_internal_map(map_point))

func internal_map_to_map(internal_map_point : Vector2) -> Vector2:
	return internal_map_point + refrence_rect.position

func map_to_internal_map(map_point : Vector2) -> Vector2:
	return map_point - refrence_rect.position
