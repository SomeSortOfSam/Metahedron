extends Map
class_name ReferenceMap

var map : Map
var center_cell : Vector2
var tile_range : int

func _init(new_tile_map : TileMap, new_map : Map, center_cell : Vector2, tile_range : int).(new_tile_map):
	map = new_map
	self.center_cell = center_cell
	self.tile_range = tile_range
	populate_people()
	populate_decorations()

func populate_people():
	for internal_cell in map.people.keys():
		var cell = MapSpaceConverter.internal_map_to_map(internal_cell, self)
		if Pathfinder.is_cell_in_range(center_cell, cell, tile_range):
			people[cell] = map.people[internal_cell]

func populate_decorations():
	for internal_cell in map.decorations.keys():
		var cell = MapSpaceConverter.internal_map_to_map(internal_cell, self)
		if Pathfinder.is_cell_in_range(center_cell, cell, tile_range):
			decorations[cell] = map.decorations[internal_cell]

func get_refrence_rect() -> Rect2:
	var top_left_position := center_cell - Vector2.ONE * tile_range
	top_left_position = map.clamp(top_left_position)
	var bottom_right_position := center_cell + Vector2.ONE * tile_range
	bottom_right_position = map.clamp(bottom_right_position)
	var size = bottom_right_position - top_left_position
	return Rect2(top_left_position,size)
