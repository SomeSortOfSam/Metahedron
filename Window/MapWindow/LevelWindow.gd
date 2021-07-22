extends MapWindow
class_name LevelWindow

export(PackedScene) var level_data

# warning-ignore:shadowed_variable
func initalize(level_data : LevelData):
	tilemap_container.add_child(level_data)
	self.map = level_data.to_map()

func _ready():
	initalize(level_data.instance() as LevelData)
	call_deferred("resize_window")
	var _connection = get_tree().connect("screen_resized", self, "resize_window")
	_connection = cursor.connect("accept_pressed",self,"get_window")

func resize_window():
	popup(get_viewport_rect())
	yield(get_tree(),"idle_frame")
	center_tilemap()

func get_window(cell : Vector2) -> MovementWindow:
	if map.is_occupied(cell):
		var movement_window = MovementWindow.get_window(cell, map, 3)
		add_child(movement_window)
		var pos = map.map_to_world(cell)
		var size = MovementWindow.range_to_size(3,map.tile_map)
		movement_window.popup(Rect2(pos,size))
		return movement_window
	return null
