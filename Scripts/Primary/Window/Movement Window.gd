extends Control
class_name MovementWindow

onready var close_button : TextureButton = $VSplitContainer/TopBar/Close
onready var cursor = $VSplitContainer/Body/Body
onready var container = $VSplitContainer/Body/Body/TilemapContainer
onready var arrow_lines : ArrowLines = $VSplitContainer/Body/Body/TilemapContainer/ArrowLines
onready var tilemap : TileMap = $VSplitContainer/Body/Body/TilemapContainer/TileMap

var map : ReferenceMap setget set_map

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

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()
	regenerate_astar()

func regenerate_astar():
	arrow_lines.astar = Pathfinder.refrence_map_to_astar(map)

func lock_window():
	close_button.hide()
	arrow_lines.disable()

func move_window(offset : Vector2):
	map.center_cell += offset
	map.repopulate_fields()
	map.repopulate_displays()
	regenerate_astar()
	resize()

func subscribe(person):
	var _connection = cursor.connect("path_accepted", person, "move_cell")
	_connection = person.connect("lock_window", self, "lock_window")
	_connection = person.connect("cell_change", self, "on_cell_change")
	_connection = person.connect("new_turn", self, "on_new_turn")
	_connection = connect("closed", person, "on_window_closed")

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	third.x = min(third.x,third.y)
	third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Window/Movement Window.tscn")
	var window : MovementWindow = packed_window.instance()
	window.call_deferred("populate_map",parent_map,cell,window_range)
	return window

func populate_map(parent_map, cell, window_range):
	self.map = ReferenceMap.new(tilemap,parent_map,cell,window_range)

func on_new_turn():
	close_button.show()

func on_cell_change(offset : Vector2):
	close_button.hide()
	move_window(offset)

func _on_Close_pressed():
	hide()
	emit_signal("closed")

func _on_TopBar_accepted_window_movement(delta):
	rect_position += delta
