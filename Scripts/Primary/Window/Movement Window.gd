extends Control
class_name MovementWindow

onready var close_button : TextureButton = $VSplitContainer/TopBar/Close
onready var cursor = $VSplitContainer/Body/Body
onready var container = $VSplitContainer/Body/Body/TilemapContainer

var map : ReferenceMap setget set_map_deferred

signal closed

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

func set_map_deferred(new_map : ReferenceMap):
	call_deferred("set_map",new_map)

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()
	cursor.set_map()
	var _connection = map.connect("position_changed", self, "resize")

func subscribe(person):
	var _connection = cursor.connect("path_accepted", person, "_on_path_accepted")
	_connection = person.connect("lock_window", self, "_on_lock_window")
	_connection = person.connect("cell_change", self, "_on_cell_change")
	_connection = person.connect("new_turn", self, "_on_new_turn")
	_connection = connect("closed", person, "_on_window_closed")

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Window/Movement Window.tscn")
	var window : MovementWindow = packed_window.instance()
	window.populate_map(parent_map,cell,window_range)
	return window

func populate_map(parent_map, cell, window_range):
	self.map = ReferenceMap.new($VSplitContainer/Body/Body/TilemapContainer/TileMap,parent_map,cell,window_range)

func _on_lock_window():
	close_button.hide()
	cursor.disable()

func _on_new_turn():
	close_button.show()

func _on_cell_change(offset : Vector2):
	map.center_cell += offset
	close_button.hide()

func _on_Close_pressed():
	hide()
	emit_signal("closed")

func _on_TopBar_accepted_window_movement(delta):
	rect_position += delta
