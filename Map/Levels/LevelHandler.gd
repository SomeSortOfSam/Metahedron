extends Node2D
class_name LevelHandler

export var packed_level_data : PackedScene

var map : Map
var is_dragging : bool = false


func _ready():
	initialize_level(validate_level_data(packed_level_data))
	recenter_map()
	get_tree().connect("screen_resized",self,"recenter_map")

func recenter_map():
	map.tile_map.position = TileMapUtilites.get_centered_position(map,get_viewport_rect().size)

func initialize_level(level_data : LevelData):
	add_child(level_data)
	map = level_data.to_map()
	intialize_cursor()

func intialize_cursor():
	var cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)
	cursor.connect("accept_pressed",map,"get_window",[self, true])

# warning-ignore:shadowed_variable
func validate_level_data(packed_level_data : PackedScene) -> LevelData:
	var unpacked_level_data := packed_level_data.instance() as LevelData
	assert(unpacked_level_data != null, "Level data for " + name + " was not of type level data")
	if unpacked_level_data:
		return unpacked_level_data
	else:
		return LevelData.new()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			is_dragging = event.is_pressed()
		if event.button_index == 4:
			map.tile_map.scale *= 1.1
		if event.button_index == 5:
			map.tile_map.scale *= .9
	if event is InputEventMouseMotion && is_dragging:
		map.tile_map.position += event.get_relative()
