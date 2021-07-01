extends WAT.Test

var tile_range := 3
var tile_range_size := Vector2.ONE * ((tile_range * 2) + 1)
var tile_map := tests_map.initalize_full_tilemap(tile_range_size,Vector2.ONE *3)
var window := LevelWindow.new(tests_map.initalize_full_tilemap(),Cursor.new())

func test_get_window():
	describe("Get window")
	window.map.units[Vector2.ONE] = Character.new()
	asserts.is_null(window.get_window(Vector2.ZERO),"Unoccupied cells do not return movement window")
	asserts.is_not_null(window.get_window(Vector2.ONE), "Occupied cells return window")

	var movement_window := window.get_window(Vector2.ONE)
	asserts.is_not_equal(movement_window.tilemap, window.tilemap, "Movement window has internal tilemap")
	

func test_size():
	describe("Size")
	var expected_window_size := tile_range_size + (Vector2.ONE *2)
	
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size contains full walkable range")
	tile_map.cell_size *= 2
	expected_window_size *= 2
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with cell size")
	tile_map.cell_size *= .5
	tile_map.scale *= 2
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with scale")

func test_position():
	describe("Position")
