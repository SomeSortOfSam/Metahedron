extends Control
class_name MovementWindow

onready var container = $VSplitContainer/Body/Body/TilemapContainer

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
	rect_position = MapSpaceConverter.map_to_global(map.center_cell,map.map)
	rect_position -= $VSplitContainer/Body/Body.rect_position
	rect_position -= container.position
	rect_position -= MapSpaceConverter.map_to_local(Vector2.ZERO, map) * container.scale
	show()

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()
	regenerate_astar()

func regenerate_astar():
	$VSplitContainer/Body/Body/TilemapContainer/ArrowLines.astar = Pathfinder.refrence_map_to_astar(map)

func lock_window():
	#TODO implement locking
	print("Locked")

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return third

# warning-ignore:shadowed_variable
static func get_window(cell : Vector2, map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Window/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	var tilemap := window.get_node("VSplitContainer/Body/Body/TilemapContainer/TileMap") as TileMap
	window.map = ReferenceMap.new(tilemap,map,cell,window_range)
	return window

func _on_Close_pressed():
	hide()

func _on_TopBar_accepted_window_movement(delta):
	rect_position += delta
