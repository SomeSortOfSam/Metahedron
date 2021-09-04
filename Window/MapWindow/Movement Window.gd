extends NinePatchRect
class_name MovementWindow

const DEFUALT_PATCH_MARGIN_LEFT = 5
const DEFUALT_PATCH_MARGIN_RIGHT = 5
const DEFUALT_PATCH_MARGIN_TOP = 35
const DEFUALT_PATCH_MARGIN_BOTTOM = 5

export var center := true

var map : ReferenceMap setget set_map

onready var cursor : Cursor
onready var tilemap_container : YSort = $Control/TilemapContainer

func _ready():
	queue_centering()

func queue_centering():
	var _connection = get_tree().connect("screen_resized", self, "center_tilemap")
	if center:
		yield(get_tree(),"idle_frame")
		center_tilemap()

func center_tilemap():
	tilemap_container.position = TileMapUtilites.get_centered_position(map.tile_map,rect_size)

func set_map(new_map : ReferenceMap):
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
	var internal_map_tiles = Pathfinder.get_walkable_tiles_in_range(center_cell,tile_range,map.map)
	for internal_tile in internal_map_tiles:
		populate_tile(internal_tile)

func populate_tile(internal_tile : Vector2):
	var internal_tilemap_tile = MapSpaceConverter.map_to_tilemap(internal_tile,map.map)
	var internal_tile_type = map.map.tile_map.get_cellv(internal_tilemap_tile)
	var internal_tile_autotile_coords = map.map.tile_map.get_cell_autotile_coord(internal_tilemap_tile.x, internal_tilemap_tile.y)
	var tile = MapSpaceConverter.internal_map_to_map(internal_tile,map)
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

func popup_around_tile(parent_map : Map,cell : Vector2):
	var veiwport_rect = get_viewport_rect()
	rect_position = get_popup_position(veiwport_rect,map,cell)
	rect_size = get_small_window_size(veiwport_rect)
	scale_maps(parent_map,cell)


func scale_maps(parent_map,cell):
	var veiwport_rect = get_viewport_rect()
	var scale = get_tilemap_scale(veiwport_rect,3)
	TileMapUtilites.scale_around_tile(parent_map.tile_map, scale, cell)
	TileMapUtilites.scale_around_tile(map.tile_map, scale, cell)
	center_tilemap()

static func get_popup_position(veiwport_rect : Rect2 ,map, cell : Vector2) -> Vector2:
	return veiwport_rect.size/2 - get_small_window_size(veiwport_rect)/2

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return veiwport_rect.size/3

static func get_tilemap_scale(veiwport_rect : Rect2, window_range : int, left = DEFUALT_PATCH_MARGIN_LEFT, right = DEFUALT_PATCH_MARGIN_RIGHT, top = DEFUALT_PATCH_MARGIN_TOP, bottom = DEFUALT_PATCH_MARGIN_BOTTOM):
	var size = get_small_window_size(veiwport_rect)
	var content_size = size - Vector2(right + left, top + bottom)
	var max_cell_size = content_size/(window_range + TileMapUtilites.NUM_BORDER_TILES)
	var square_cell_size = Vector2(min(max_cell_size.x,max_cell_size.y),min(max_cell_size.x,max_cell_size.y))
	return square_cell_size / TileMapUtilites.DEFUALT_CELL_SIZE

static func get_window(cell : Vector2, map, window_range : int, center_on_ready := true) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	window.center = center_on_ready
	var tilemap := window.get_node("Control/TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	window.populate(window_range,cell)
	return window
