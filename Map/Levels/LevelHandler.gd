extends Node2D
class_name LevelHandler

export var packed_level_data : PackedScene

var map : Map

func _ready():
	initialize_level(validate_level_data(packed_level_data))

func initialize_level(level_data : LevelData):
	add_child(level_data)
	map = level_data.to_map()
	intialize_cursor()

func intialize_cursor():
	var cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)
	cursor.connect("accept_pressed",map,"get_window",[self])

# warning-ignore:shadowed_variable
func validate_level_data(packed_level_data : PackedScene) -> LevelData:
	var unpacked_level_data := packed_level_data.instance() as LevelData
	assert(unpacked_level_data != null, "Level data for " + name + " was not of type level data")
	if unpacked_level_data:
		return unpacked_level_data
	else:
		return LevelData.new()


