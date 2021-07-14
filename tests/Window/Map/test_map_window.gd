extends "res://addons/gut/test.gd"

const MAP_WINDOW_SCENE_PATH := "res://Window/MapWindow/MapWindow.tscn"
var packed_map_window : PackedScene = preload(MAP_WINDOW_SCENE_PATH)
var map_window :MapWindow

func before_each():
	map_window = packed_map_window.instance() as MapWindow
	add_child_autofree(map_window)

func test_initalization():
	pre_map_initalzation_tests()
	add_map(Map.new(TileMap.new()))
	post_map_initalization_tests()

func pre_map_initalzation_tests():
	assert_not_null(map_window.tilemap_container)
	assert_null(map_window.map)

func add_map(map : Map):
	autofree(map.tile_map)
	map_window.map = map

func post_map_initalization_tests():
	assert_not_null(map_window.map)
	assert_not_null(map_window.cursor)
	assert_eq(map_window.cursor.map, map_window.map)
