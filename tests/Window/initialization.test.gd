extends WAT.Test

func test_get_window():
	describe("Get window")
	var window := LevelWindow.new(tests_map.initalize_full_tilemap(),Cursor.new())
	window.map.units[Vector2.ONE] = Character.new()
	asserts.is_null(window.get_window(Vector2.ZERO),"Unoccupied cells do not return movement window")
	asserts.is_not_null(window.get_window(Vector2.ONE), "Occupied cells return window")

func test_movement_window():
	describe("Size and position")
	var tile_range := 3
	var tile_range_size := Vector2.ONE * ((tile_range * 2) + 1)
	var tile_map := tests_map.initalize_full_tilemap(tile_range_size )
	var expected_window_size := tile_range_size + (Vector2.ONE *2)
	
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size contains full walkable range")
	tile_map.cell_size *= 2
	expected_window_size *= 2
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with cell size")
	tile_map.cell_size *= .5
	tile_map.scale *= 2
	asserts.is_equal(expected_window_size ,MovementWindow.range_to_size(tile_range,tile_map),"Size scales with scale")
