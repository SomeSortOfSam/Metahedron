extends WAT.Test

func test_index_generation():
	var map := tests_map.initalize_full_map()
	var has_duplicate := false
	var checked := []
	for x in tests_map.SIZE.x:
		for y in tests_map.SIZE.y:
			var index := Pathfinder.map_to_index(map,Vector2(x,y))
			has_duplicate = has_duplicate or checked.find(index) != -1
			checked.append(index)
	asserts.is_false(has_duplicate, "Does not create duplicates")

func test_is_occupied():
	describe("is_occupied")
	var map = tests_map.initalize_full_map()
	
	asserts.is_false(map.is_occupied(Vector2.ZERO), "false when not occupied")
	add_unit(map, tests_map.SIZE - Vector2.ONE)
	asserts.is_true(map.is_occupied(tests_map.SIZE - Vector2.ONE), "true when occupied")

func test_is_walkable():
	var map := tests_map.initalize_full_map(Vector2(3,1))
	map.tile_map.set_cellv(Vector2.ZERO,-1)
	asserts.is_true(map.is_walkable(Vector2.RIGHT), "true when full")
	asserts.is_false(map.is_walkable(Vector2.ZERO), "false when empty")
	asserts.is_true(map.is_walkable(Vector2(2,0)), "true when occupied")

func add_unit(map : Map, map_point : Vector2):
	map.units[map_point] = Character.new()

func setup_walkable_map() -> Map:
	var map := tests_map.initalize_full_map(Vector2(5,2))
	map.tile_map.set_cellv(Vector2.ZERO,-1)
	var tile_set = TileSet.new()
	tile_set.create_tile(1)
	tile_set.tile_set_shape(1,0,RectangleShape2D.new())
	map.tile_map.tile_set = tile_set
	for i in 5:
		map.tile_map.set_cell(i,1,1)
	return map

func test_get_walkable_tiles():
	var map = setup_walkable_map()
	describe("Get walkable tiles")
	var tiles := Pathfinder.get_walkable_tiles_in_range(map,Vector2.RIGHT,3)
	asserts.is_equal(tiles.find(Vector2.ZERO),-1,"Unwalkable tiles not included " + str(Vector2.ZERO))
	asserts.is_not_equal(tiles.find(Vector2.RIGHT),-1, "Starting tile included " + str(Vector2.RIGHT))
	asserts.is_equal(tiles.find((Vector2(5,0))),-1, "Out of range tile not included " + str(Vector2(4,0)))
	asserts.is_equal(tiles.find(Vector2.DOWN),-1, "Tiles with collision not included " + str(Vector2(Vector2.DOWN)))
