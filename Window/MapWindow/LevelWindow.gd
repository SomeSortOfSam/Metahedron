extends MapWindow
class_name LevelWindow

export(PackedScene) var level_data

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
	center_tilemap()

func get_window(cell : Vector2) -> MovementWindow:
	print("Get window at " + str(cell))
	return MovementWindow.new() if map.is_occupied(cell) else null
