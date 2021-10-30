extends "res://addons/gut/test.gd"

func test_index_generation():
	var list := []
	for x in range(-3,4):
		for y in range(-3,4):
			var got = MapSpaceConverter.map_to_index(Vector2(x,y))
			assert_eq(got, MapSpaceConverter.map_to_index(Vector2(x,y)),"Indexing is consitent")
			assert_eq(list.find(got),-1,"Indexing is unique")
			list.append(got)

func test_refrence_astar_generation():
	#arrange
	var map = ReferenceMap.new(add_child_autofree(TileMap.new()),Map.new(add_child_autofree(TileMap.new())),Vector2.ONE*2,2)
	for x in range(5):
		for y in range(5):
			map.map.tile_map.set_cell(x,y,0)
	map.repopulate_tilemap()
	#act
	var astar := Pathfinder.map_to_astar(map)
	#assert
	astar_asserts(astar,MapSpaceConverter.map_to_index(Vector2.ZERO),MapSpaceConverter.map_to_index(Vector2.RIGHT),MapSpaceConverter.map_to_index(Vector2.RIGHT*2))

func test_map_astar_generation():
	#arrange
	var map = Map.new(add_child_autofree(TileMap.new()))
	for x in range(5):
		for y in range(5):
			map.tile_map.set_cell(x,y,0)
	#act
	var astar := Pathfinder.map_to_astar(map)
	#assert
	astar_asserts(astar,MapSpaceConverter.map_to_index(Vector2.ONE*2),MapSpaceConverter.map_to_index(Vector2(1,2)),MapSpaceConverter.map_to_index(Vector2.DOWN*2))

func astar_asserts(astar : AStar2D, center_cell : int, neighbor_cell : int, distant_cell : int):
	assert_true(astar.has_point(center_cell),"Center cell included")
	assert_true(astar.has_point(neighbor_cell),"Neigbor cell included")
	assert_true(astar.are_points_connected(center_cell,neighbor_cell),"Center Cell is connected to neighbor cell")
	assert_true(astar.has_point(distant_cell),"Distant cell included")
	assert_false(astar.are_points_connected(center_cell,distant_cell),"Center Cell is not connected to distant cell")
	assert_true(astar.are_points_connected(neighbor_cell,distant_cell),"Neighbor Cell is connected to distant cell")

class Test_is_path_walkable:
	extends"res://addons/gut/test.gd"

	func test_valid_path():
		#arrange
		var map := ReferenceMap.new(add_child_autofree(TileMap.new()),Map.new(add_child_autofree(TileMap.new())),Vector2.ONE*2,2)
		for x in range(5):
			for y in range(5):
				map.map.tile_map.set_cell(x,y,0)
		map.repopulate_tilemap()
		#act 
		#assert
		assert_true(Pathfinder.is_path_walkable(Vector2.DOWN*2,map))
		#act 
		map.map.add_person(Person.new(Character.new(),false,Vector2(1,2)))
		map.repopulate_fields()
		#assert
		assert_true(Pathfinder.is_path_walkable(Vector2.DOWN*2,map))
	
	func test_invalid_path():
		#arrange
		var map = ReferenceMap.new(add_child_autofree(TileMap.new()),Map.new(add_child_autofree(TileMap.new())),Vector2.ONE*2,2)
		for x in range(2,5):
			for y in range(5):
				map.map.tile_map.set_cell(x,y,0)
		map.map.tile_map.set_cell(0,2,0)
		map.repopulate_tilemap()
		#act 
		#assert
		assert_false(Pathfinder.is_path_walkable(Vector2.LEFT*2,map))
