extends "res://addons/gut/test.gd"

var tile_range : int
var tile_range_size : Vector2
var tile_map : TileMap
var window : LevelWindow

func before_each():
	tile_range = 3
	tile_range_size = Vector2.ONE * ((tile_range * 2) + 1)
	tile_map = tests_map.initalize_full_tilemap(tile_range_size,Vector2.ONE *3)
	window = LevelWindow.new(tests_map.initalize_full_tilemap(),Cursor.new())

func test_get_window():
	window.map.units[Vector2.ONE] = Character.new()
	assert_null(window.get_window(Vector2.ZERO),"Unoccupied cells do not return movement window")
	var get_window_window := window.get_window(Vector2.ONE)
	assert_not_null(get_window_window, "Occupied cells return window")
	get_window_window.tilemap.free()
	get_window_window.free()
	

	var movement_window := window.get_window(Vector2.ONE)
	assert_ne(movement_window.tilemap, window.tilemap, "Movement window has internal tilemap")
	movement_window.tilemap.free()
	movement_window.free()

func test_size():
	var expected_window_size := tile_range_size + (Vector2.ONE *2)
	
	assert_eq(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size contains full walkable range")
	tile_map.cell_size *= 2
	expected_window_size *= 2
	assert_eq(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with cell size")
	tile_map.cell_size *= .5
	tile_map.scale *= 2
	assert_eq(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with scale")

func test_get_units():
	pending()

func after_each():
	tile_map.free()
	window.free()
