extends "res://addons/gut/test.gd"

const MAP_WINDOW_SCENE_PATH := "res://Window/MapWindow/MapWindow.tscn"

func test_initalization():
	var packed_map_window := load(MAP_WINDOW_SCENE_PATH)
	var map_window := packed_map_window.instance() as MapWindow
	add_child_autofree(map_window)
	assert_not_null(map_window.path)
	assert_not_null(map_window.follower)
	assert_not_null(map_window.tilemap_container)
	assert_null(map_window.map)
	var map := Map.new(TileMap.new())
	map_window.tilemap_container.add_child(map.tile_map)
	map_window.map = map
	assert_not_null(map_window.map)
	assert_not_null(map_window.cursor)
	assert_eq(map_window.cursor.map, map_window.map)

func test_centering():
	pending()
