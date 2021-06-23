extends WAT.Test

func test_initializaton():
	var level_window = load("res://Window/MapWindow/LevelWindow.tscn")
	var level_window_instance = level_window.instance()
	get_tree().get_root().add_child(level_window_instance)
	asserts.is_not_null(level_window_instance.map)
