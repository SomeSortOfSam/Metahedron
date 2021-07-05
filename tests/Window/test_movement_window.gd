extends "res://addons/gut/test.gd"

func test_get_window():
	var map := tests_map.initalize_full_map(tests_map.SIZE)
	var window : MovementWindow = MovementWindow.get_window(Vector2.ZERO, map, 3)
