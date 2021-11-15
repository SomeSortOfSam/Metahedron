extends Control
class_name MovementWindow, "res://Assets/Editor Icons/MovementWindow.png"
## Application window what lets units move. Main element of the game.

onready var close_button : TextureButton = $VSplitContainer/TopBar/Close
onready var cursor : WindowCursor = $VSplitContainer/Body/Body
onready var container : MapScaler = $VSplitContainer/Body/Body/TilemapContainer

onready var outline0 : ColorRect = $VSplitContainer/Body/Outline
onready var outline1 : ColorRect = $VSplitContainer/TopBar/Outline

var map : ReferenceMap setget set_map

var player_accessible := true

signal requesting_close()

func _ready():
	hide()
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
	map.repopulate_displays()
	cursor.map = new_map
	var _connection = map.connect("position_changed", container, "correct_transform")

func subscribe(person):
	player_accessible = !person.is_evil
	
	var _connection
	
	if (player_accessible):
		_connection = connect("requesting_close", person, "_on_window_requesting_close")
		_connection = cursor.connect("position_accepted", self, "_on_cursor_position_accepted",[person])
		_connection = person.connect("new_turn", self, "_on_person_new_turn")
	else:
		lock_window()
	
	_connection = person.connect("move", self, "_on_person_move")
	_connection = person.connect("close_window", self, "_on_person_close_window")
	_connection = person.connect("open_window", self, "_on_person_open_window")	

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	if Settings.new().squareWindows:
		third.x = min(third.x,third.y)
		third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Interface/Movement Window.tscn")
	var window : MovementWindow = packed_window.instance()
	window.populate_map(parent_map,cell,window_range)
	return window

func populate_map(parent_map, cell, window_range):
	var new_map = ReferenceMap.new($VSplitContainer/Body/Body/TilemapContainer/TileMap,parent_map,cell,window_range)
	new_map.outer_tile_map = $VSplitContainer/Body/Body/TilemapContainer/OuterMap
	call_deferred("set_map",new_map)

func lock_window():
	close_button.hide()
	cursor.enable(false)

func _on_person_new_turn():
	close_button.show()
	cursor.enable(true)

func _on_person_move(delta : Vector2):
	map.center_cell += delta
	lock_window()

func _on_Close_pressed():
	emit_signal("requesting_close")

func _on_person_close_window():
	hide()

func _on_person_open_window():
	popup_around_tile()

func _on_cursor_position_accepted(delta : Vector2, person):
	person.cell += delta

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
