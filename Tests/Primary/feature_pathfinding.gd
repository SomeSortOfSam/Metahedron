extends "res://addons/gut/test.gd"

func test_index_generation():
	var list := []
	for x in range(-3,4):
		for y in range(-3,4):
			var got = MapSpaceConverter.refrence_map_to_index(Vector2(x,y))
			assert_eq(got, MapSpaceConverter.refrence_map_to_index(Vector2(x,y)),"Indexing is consitent")
			assert_eq(list.find(got),-1,"Indexing is unique")
			list.append(got)

func test_refrence_astar_generation():
	#arrange
	var map = ReferenceMap.new(add_child_autofree(TileMap.new()),Map.new(add_child_autofree(TileMap.new())),Vector2.ONE*2,2)
	for x in range(5):
		for y in range(5):
			map.map.tile_map.set_cell(x,y,0)
	#act
	var astar := Pathfinder.refrence_map_to_astar(map)
	#assert
	var points := astar.get_points()
	var center_index := MapSpaceConverter.refrence_map_to_index(Vector2.ZERO)
	print(str(points) + " " + str(center_index))
	assert_ne(points.find(center_index),-1,"Center cell included")	