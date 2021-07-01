extends WindowDialog
class_name MovementWindow

onready var tilemap : TileMap = $TileMap

var map : RefrenceMap

func _init(max_range := 3, map_to_refrence := Map.new()):
	tilemap = TileMap.new()
	map = RefrenceMap.new(map_to_refrence)
	popup_centered(range_to_size(max_range, tilemap))

func populate_tilemap(tile_range : int, cell : Vector2):
	var internal_map_tiles := Pathfinder.get_walkable_tiles_in_range(map,cell,tile_range)
	for internal_tile in internal_map_tiles:
		tilemap.set_cellv(map.internal_map_to_map(internal_tile),map.map.tile_map.get_cellv(internal_tile))

static func range_to_size(max_range : int, tile_map : TileMap) -> Vector2:
	return Vector2.ONE * ((max_range * 2) + 3) * tile_map.cell_size * tile_map.scale

static func get_popup_position(cell : Vector2) -> Vector2:
	return cell

static func get_window(cell : Vector2, map : Map, window_range : int) -> MovementWindow:
	return load("res://Window/MapWindow/Movement Window.gd").new(window_range, map)
