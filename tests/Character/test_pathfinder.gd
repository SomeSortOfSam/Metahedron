extends "res://addons/gut/test.gd"

func test_get_neighbors():
	var map := Map.new(autofree(TileMap.new()))
	assign_tiles(map.tile_map)
	var neighbors := Pathfinder.get_neighbors(Vector2.ONE, map)
	assert_does_not_have(neighbors, Vector2.ONE, "Does not include self")
	assert_does_not_have(neighbors, Vector2(1,0), "Does not have empty")
	assert_does_not_have(neighbors, Vector2(3,1), "Does not have far away neighbors")
	assert_does_not_have(neighbors, Vector2.ZERO, "Does not have diaganal neighbors")
	assert_has(neighbors, Vector2(0,1), "Has neighbor")
	assert_has(neighbors, Vector2(1,2), "Has neighbor")

func assign_tiles(tilemap : TileMap):
	tilemap.set_cell(0,0,1)
	tilemap.set_cell(0,1,1)
	tilemap.set_cell(1,1,1)
	tilemap.set_cell(3,1,1)
	tilemap.set_cell(1,2,1)
