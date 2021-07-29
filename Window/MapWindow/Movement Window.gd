extends MapWindow
class_name MovementWindow

func populate(tile_range : int, center_cell : Vector2):
	populate_tilemap(tile_range,center_cell)
	populate_units()
	populate_decorations()

func populate_tilemap(tile_range : int, center_cell : Vector2):
	var internal_map_tiles = map.map.get_walkable_tiles_in_range(center_cell,tile_range)
	for internal_tile in internal_map_tiles:
		var internal_tile_type = map.map.tile_map.get_cellv(map.map.map_to_tilemap(internal_tile))
		var tile = map.internal_map_to_map(internal_tile)
		map.tile_map.set_cellv(tile,internal_tile_type)

func populate_units():
	pass

func populate_decorations():
	pass

func popup_around_tile(cell : Vector2):
	var pos = get_popup_position(map,cell)
	var size = range_to_size(3,map.tile_map)
	popup(Rect2(pos,size))

static func range_to_size(max_range : int, tile_map : TileMap) -> Vector2:
	return Vector2.ONE * ((max_range * 2) + 3) * tile_map.cell_size * tile_map.scale

static func get_popup_position(map : Map, cell : Vector2) -> Vector2:
	return map.map_to_global(cell)

static func get_window(cell : Vector2, map : Map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	var tilemap := window.get_node("TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	window.populate(window_range,cell)
	return window
