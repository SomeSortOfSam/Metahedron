extends Control
class_name MovementWindow

onready var close_button : TextureButton = $VSplitContainer/TopBar/Close
onready var cursor : WindowCursor = $VSplitContainer/Body/Body
onready var container : MapScaler = $VSplitContainer/Body/Body/TilemapContainer

onready var outline0 : ColorRect = $VSplitContainer/Body/Outline
onready var outline1 : ColorRect = $VSplitContainer/TopBar/Outline

var map : ReferenceMap setget set_map

var player_accessible := true

signal closed

func _ready():
	resize()
	var _connection = get_tree().connect("screen_resized",self,"resize")

func resize():
	rect_size = get_small_window_size(get_viewport_rect())

func popup_around_tile():
	show()
	call_deferred("call_deferred","center_around_tile",map.center_cell) #1 frame to render, 1 frame for rect_size to update


func center_around_tile(tile : Vector2):
	rect_position = MapSpaceConverter.map_to_global(tile,map.map)
	rect_position -= -rect_global_position + container.global_position
	rect_position -= MapSpaceConverter.map_to_local(Vector2.ZERO, map) * container.scale

func set_map(new_map : ReferenceMap):
	map = new_map
	cursor.map = new_map
	map.repopulate_displays()
	var _connection = map.connect("position_changed", self, "resize")
	_connection = map.connect("position_changed", container, "correct_transform")

func subscribe(person):
	player_accessible = !person.is_evil
	
	var _connection
	
	if (player_accessible):
		_connection = cursor.connect("path_accepted", person, "_on_path_accepted")
		_connection = connect("closed", person, "_on_window_closed")
	else:
		_on_lock_window()
	
	_connection = person.connect("lock_window", self, "_on_lock_window")
	_connection = person.connect("cell_change", self, "_on_cell_change")
	_connection = person.connect("new_turn", self, "_on_new_turn")
	

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	if Settings.new().squareWindows:
		third.x = min(third.x,third.y)
		third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Window/Movement Window.tscn")
	var window : MovementWindow = packed_window.instance()
	window.populate_map(parent_map,cell,window_range)
	return window

func populate_map(parent_map, cell, window_range):
	var new_map = ReferenceMap.new($VSplitContainer/Body/Body/TilemapContainer/TileMap,parent_map,cell,window_range)
	new_map.outer_tile_map = $VSplitContainer/Body/Body/TilemapContainer/OuterMap
	call_deferred("set_map",new_map)

func _on_lock_window():
	close_button.hide()
	cursor.disable()

func _on_new_turn():
	close_button.show()
	cursor.enable()

func _on_cell_change(offset : Vector2):
	map.center_cell += offset
	close_button.hide()

func _on_Close_pressed():
	hide()
	emit_signal("closed")

func _on_TopBar_accepted_window_movement(delta):
	if (player_accessible):
		rect_position += delta

func _on_Window_focus_entered():
	if (player_accessible):
		outline0.color.v += .05
		outline1.color.v += .05

func _on_Window_focus_exited():
	if (player_accessible):
		outline0.color.v -= .05
		outline1.color.v -= .05
