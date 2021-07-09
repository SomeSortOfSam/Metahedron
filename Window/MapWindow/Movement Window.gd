extends MapWindow
class_name MovementWindow

onready var tilemap : TileMap = $TileMap

var map : ReferenceMap

func populate_tilemap(tile_range : int, cell : Vector2):
	var internal_map_tiles := Pathfinder.get_walkable_tiles_in_range(map,cell,tile_range)
	for internal_tile in internal_map_tiles:
		tilemap.set_cellv(map.internal_map_to_map(internal_tile),map.map.tile_map.get_cellv(internal_tile))

static func range_to_size(max_range : int, tile_map : TileMap) -> Vector2:
	return Vector2.ONE * ((max_range * 2) + 3) * tile_map.cell_size * tile_map.scale

static func get_popup_position(cell : Vector2) -> Vector2:
	return cell

static func get_window(cell : Vector2, map : Map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instace() as MovementWindow
	window.map = ReferenceMap.new(map,cell,window_range)
	window.populate_tilemap(window_range,cell)
	return window
