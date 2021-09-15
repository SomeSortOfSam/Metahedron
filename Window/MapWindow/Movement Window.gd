extends NinePatchRect
class_name MovementWindow

onready var container = $Control/TilemapContainer

var map : ReferenceMap setget set_map

func _ready():
	resize()
	var _connection = get_tree().connect("screen_resized",self,"resize")

func resize():
	rect_size = get_small_window_size(get_viewport_rect())
	container.scale()
	container.center()

func popup_around_tile():
	resize()
	var delta = MapSpaceConverter.map_to_global(MapSpaceConverter.internal_map_to_map(map.center_cell, map), map)
	delta += get_node("Control").rect_position
	rect_position = MapSpaceConverter.map_to_global(map.center_cell,map.map) -delta

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()

func _on_DraggableArea_accepted_window_movement(delta):
	rect_position += delta

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return veiwport_rect.size/3

# warning-ignore:shadowed_variable
static func get_window(cell : Vector2, map, window_range : int, center_on_ready := true) -> MovementWindow:
	var packed_window := load("res://Window/MapWindow/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	var tilemap := window.get_node("Control/TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	return window
