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

func test_centering(params = use_parameters(MapTestUtilites.get_map_params())):
	setup_centering_window()
	map_window.center_tilemap()
	assert_eq(map_window.tilemap_container.position, Vector2.ONE * 9 / 2, "Mapless map window centers with tilemap container position")
	var parent := Node2D.new()
	map_window.add_child(parent)
	add_map(MapTestUtilites.params_to_map(params,parent))
	map_window.center_tilemap()
	assert_eq(map_window.map.map_to_world(Vector2.ONE), (Vector2.ONE * 9 / 2), "Map window centers on midpoint of tilemap " + MapTestUtilites.get_parameter_description(params))

func setup_centering_window():
	map_window.get_close_button().free()
	map_window.anchor_top = 0
	map_window.anchor_bottom = 0
	map_window.anchor_left = 0
	map_window.anchor_right = 0
	map_window.margin_left = 0
	map_window.margin_top = 0
	map_window.margin_right = 9
	map_window.margin_bottom = 9
