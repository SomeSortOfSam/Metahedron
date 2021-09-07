extends "res://addons/gut/test.gd"

func test_conversions(params = use_parameters(MapTestUtilites.get_map_params())):
	var parent = add_child_autofree(Node2D.new())
	var map := MapTestUtilites.params_to_map(params,parent)
	run_conversion_tests_with_each_starting_point(map, params)

func run_conversion_tests_with_each_starting_point(parent_map, params):
	for x in MapTestUtilites.SIZE.x:
		for y in MapTestUtilites.SIZE.y:
			var refrence_map := ReferenceMap.new(autofree(TileMap.new()),parent_map,Vector2(x,y),2)
			run_conversion_tests(refrence_map, params)

func run_conversion_tests(refrence_map : ReferenceMap, params):
	for x in MapTestUtilites.SIZE.x:
		for y in MapTestUtilites.SIZE.y:
			run_conversion_test(refrence_map, Vector2(x,y), params)

func run_conversion_test(refrence_map : ReferenceMap, cell : Vector2, params):
	var internal_cell : Vector2 = cell + refrence_map.center_cell
	assert_eq(MapSpaceConverter.map_to_internal_map(cell, refrence_map), internal_cell, "Map to internal cell" + MapTestUtilites.get_parameter_description(params))
	assert_eq(cell, MapSpaceConverter.internal_map_to_map(internal_cell, refrence_map), "internal cell to map " + MapTestUtilites.get_parameter_description(params))
