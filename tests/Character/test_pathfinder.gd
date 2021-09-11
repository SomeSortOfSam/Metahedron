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

func test_get_astar():
	var map := MapTestUtilites.initalize_full_map(Vector2.ONE * 5)
	add_child_autofree(map.tile_map)
	var refrence_map = ReferenceMap.new(add_child_autofree(TileMap.new()), map,Vector2.ONE * 2, 2)
	var astar = Pathfinder.refrence_map_to_astar(refrence_map)
	var indexes = astar.get_points()
	
	assert_not_null(astar)
	assert_does_not_have(indexes,Vector2.ZERO,"Astar does not have out of range tiles")
	assert_has(indexes,1)
	assert_eq(astar.get_point_connections(1).size(),4)
	assert_eq(astar.get_id_path(1,MapSpaceConverter.refrence_map_to_index(Vector2(2,0))).size(),3,"Path is populated")
