extends NinePatchRect
class_name MovementWindow

const DEFUALT_PATCH_MARGIN_LEFT = 5
const DEFUALT_PATCH_MARGIN_RIGHT = 5
const DEFUALT_PATCH_MARGIN_TOP = 35
const DEFUALT_PATCH_MARGIN_BOTTOM = 5

export var center := true

var map : ReferenceMap setget set_map
var is_dragging : bool = false

onready var cursor : Cursor
onready var tilemap_container : YSort = $Control/TilemapContainer

func _ready():
	queue_centering()

func queue_centering():
	var _connection = get_tree().connect("screen_resized", self, "reset_size")
	if center:
		yield(get_tree(),"idle_frame")
		center_tilemap()

func center_tilemap():
	tilemap_container.position = TileMapUtilites.get_centered_position(map.tile_map,useable_rect_size())

func useable_rect_size():
	var size = rect_size 
	size.x -= DEFUALT_PATCH_MARGIN_LEFT + DEFUALT_PATCH_MARGIN_RIGHT
	size.y -= DEFUALT_PATCH_MARGIN_BOTTOM + DEFUALT_PATCH_MARGIN_TOP
	return size

func reset_size():
	rect_size = get_small_window_size(get_viewport_rect())
	map.tile_map.scale = get_tilemap_scale(get_viewport_rect(),map.tile_range)
	center_tilemap()

func set_map(new_map : ReferenceMap):
	map = new_map
	map.connect("repopulated",self,"reinitalize_cursor")
	map.repopulate_displays()

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)

func scale_maps():
	var scale = get_tilemap_scale(get_viewport_rect(),3)
	TileMapUtilites.scale_around_tile(map.map.tile_map, scale, map.center_cell)
	map.tile_map.scale = get_tilemap_scale(get_viewport_rect(),map.tile_range)
	center_tilemap()

func popup_around_tile():
	rect_size = get_small_window_size(get_viewport_rect())
	scale_maps()
	rect_position = get_popup_position(map,rect_position)

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return veiwport_rect.size/3

static func get_popup_position(map, rect_position):
	var position_delta = MapSpaceConverter.map_to_global(MapSpaceConverter.internal_map_to_map(map.center_cell, map), map)-rect_position
	return MapSpaceConverter.map_to_global(map.center_cell, map.map) - position_delta

static func get_tilemap_scale(veiwport_rect : Rect2, window_range : int, left = DEFUALT_PATCH_MARGIN_LEFT, right = DEFUALT_PATCH_MARGIN_RIGHT, top = DEFUALT_PATCH_MARGIN_TOP, bottom = DEFUALT_PATCH_MARGIN_BOTTOM):
	var size = get_small_window_size(veiwport_rect)
	var content_size = size - Vector2(right + left, top + bottom)
	var max_cell_size = content_size/(window_range + TileMapUtilites.NUM_BORDER_TILES)
	var square_cell_size = Vector2(min(max_cell_size.x,max_cell_size.y),min(max_cell_size.x,max_cell_size.y))
	return square_cell_size / TileMapUtilites.DEFUALT_CELL_SIZE

func _gui_input(event):
	if event is InputEventMouse:
		if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
			is_dragging = event.pressed
		if event is InputEventMouseMotion && is_dragging:
			var hypothetical = get_rect()
			hypothetical.position += event.get_relative()
			if get_viewport_rect().encloses(hypothetical):
				rect_position += event.get_relative()

static func get_window(cell : Vector2, map, window_range : int, center_on_ready := true) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	window.center = center_on_ready
	var tilemap := window.get_node("Control/TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	return window

