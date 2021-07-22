extends "res://addons/gut/test.gd"

var level_window : LevelWindow

func initialize_level_window():
	var level_data = LevelData.new()
	level_data.add_unit(Vector2.ZERO)
	level_window = load("res://Window/MapWindow/LevelWindow.tscn").instance() as LevelWindow
	level_window.tilemap_container = level_window.get_node("TilemapContainer")
	level_window.initalize(level_data)

func before_each():
	initialize_level_window()

func test_get_movement_window():
	assert_has_method(level_window,"get_window")
	if level_window.has_method("get_window"):
		var movement_window = level_window.get_window(Vector2.ZERO)
		assert_not_null(movement_window)
		assert_eq_deep(movement_window, level_window.get_window(Vector2.ZERO))
