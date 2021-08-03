extends Map
class_name ReferenceMap

var map : Map
var rect : Rect2

func _init(new_tile_map : TileMap, new_map : Map, center_cell : Vector2, tile_range : int).(new_tile_map):
	map = new_map
	rect = range_to_rect(center_cell,tile_range)
	get_units()
	get_decorations()

func get_units():
	for internal_cell in map.people.keys():
		var cell = internal_map_to_map(internal_cell)
		if cell < rect.size && cell >= Vector2.ZERO:
			people[cell] = map.people[internal_cell]

func get_decorations():
	for internal_cell in map.decorations.keys():
		var cell = internal_map_to_map(internal_cell)
		if cell < rect.size && cell >= Vector2.ZERO:
			decorations[cell] = map.decorations[internal_cell]

func is_walkable(map_point: Vector2) -> bool:
	return map.is_walkable(map_to_internal_map(map_point))

func internal_map_to_map(internal_map_point : Vector2) -> Vector2:
	return internal_map_point - rect.position

func map_to_internal_map(map_point : Vector2) -> Vector2:
	return map_point + rect.position

func range_to_rect(center_cell : Vector2, tile_range : int) -> Rect2:
	var top_left_position := center_cell - Vector2.ONE * tile_range
	top_left_position = map.clamp(top_left_position)
	var bottom_right_position := center_cell + Vector2.ONE * tile_range
	bottom_right_position = map.clamp(bottom_right_position)
	var size = bottom_right_position - top_left_position
	return Rect2(top_left_position,size)
