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

func get_window(cell : Vector2 , popup := true) -> MovementWindow:
	if map.is_occupied(cell):
		var person = map.people[cell]
		var movement_window : MovementWindow = map.get_window(person)
		if !movement_window:
			movement_window = add_movement_window(cell, popup, person)
		if popup:
			movement_window.popup_around_tile(cell)
		return movement_window
	return null

func add_movement_window(cell : Vector2, popup : bool, person):
	map.add_window(MovementWindow.get_window(cell,map,3, popup), person)
	var movement_window = map.get_window(person)
	get_tree().current_scene.add_child(movement_window)
	return movement_window
