extends Control
class_name MovementWindow

export var center := true

var map : Map setget set_map

onready var cursor : Cursor
onready var tilemap_container : YSort = $Control/TilemapContainer

func _ready():
	var _connection = get_tree().connect("screen_resized", self, "center_tilemap")
	if center:
		yield(get_tree(),"idle_frame")
		center_tilemap()

func set_map(new_map : Map):
	map = new_map
	reparent_map()
	reinitalize_cursor()

func reparent_map():
	if map.tile_map.get_parent():
		map.tile_map.get_parent().remove_child(map.tile_map)
	if !tilemap_container:
		tilemap_container = $Control/TilemapContainer
	tilemap_container.add_child(map.tile_map)

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)

func populate(tile_range : int, center_cell : Vector2):
	populate_tilemap(tile_range,center_cell)
	populate_units()
	populate_decorations()

func populate_tilemap(tile_range : int, center_cell : Vector2):
	var internal_map_tiles = map.map.get_walkable_tiles_in_range(center_cell,tile_range)
	for internal_tile in internal_map_tiles:
		populate_tile(internal_tile)

func populate_tile(internal_tile : Vector2):
	var internal_tilemap_tile = map.map.map_to_tilemap(internal_tile)
	var internal_tile_type = map.map.tile_map.get_cellv(internal_tilemap_tile)
	var internal_tile_autotile_coords = map.map.tile_map.get_cell_autotile_coord(internal_tilemap_tile.x, internal_tilemap_tile.y)
	var tile = map.internal_map_to_map(internal_tile)
# warning-ignore:narrowing_conversion
	map.tile_map.set_cell(tile.x, tile.y,clamp(internal_tile_type - 1,0,100),false,false,false,internal_tile_autotile_coords)

func populate_units():
	for cell in map.people:
		var unit := Unit.new()
		map.tile_map.add_child(unit)
		unit.subscribe(map.people[cell],map)
		unit.is_icon = false
		unit._sprite.animation = "Idel"

func populate_decorations():
	pass

func popup_around_tile(cell : Vector2):
	var pos = get_popup_position(map,cell)
	var size = get_small_window_size()
#	popup(Rect2(pos,size))

func center_tilemap():
	tilemap_container.position = TileMapUtilites.get_centered_position(map,rect_size)

func get_small_window_size() -> Vector2:
	var third = get_viewport_rect().size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return third

static func get_popup_position(map, cell : Vector2) -> Vector2:
	return map.map_to_global(cell)

static func get_window(cell : Vector2, map, window_range : int, center_on_ready := true) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	window.center = center_on_ready
	var tilemap := window.get_node("Control/TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	window.populate(window_range,cell)
	return window
