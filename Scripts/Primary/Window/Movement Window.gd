extends Control
class_name MovementWindow

onready var close_button : TextureButton = $VSplitContainer/TopBar/Close

onready var container = $VSplitContainer/Body/Body/TilemapContainer
onready var arrow_lines : ArrowLines = $VSplitContainer/Body/Body/TilemapContainer/ArrowLines
onready var tilemap : TileMap = $VSplitContainer/Body/Body/TilemapContainer/TileMap

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
	center_around_tile(map.center_cell)
	show()

func center_around_tile(tile : Vector2):
	rect_position = MapSpaceConverter.map_to_global(tile,map.map)
	rect_position -= container.global_position - rect_global_position
	rect_position -= MapSpaceConverter.map_to_local(Vector2.ZERO, map) * container.scale

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()
	regenerate_astar()

func regenerate_astar():
	arrow_lines.astar = Pathfinder.refrence_map_to_astar(map)

func lock_window():
	#TODO implement locking
	print("Locked")

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Window/Movement Window.tscn")
	var window := packed_window.instance() as MovementWindow
	window.call_deferred("populate_map",parent_map,cell,window_range)
	return window

func populate_map(parent_map, cell, window_range):
	self.map = ReferenceMap.new(tilemap,parent_map,cell,window_range)

func _on_Close_pressed():
	hide()

func _on_TopBar_accepted_window_movement(delta):
	rect_position += delta
