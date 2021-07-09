extends "res://addons/gut/test.gd"

func test_conversions(params = use_parameters(generate_conversion_paramaters())):
	var map := tests_map.initalize_full_map(tests_map.SIZE)
	var refrence_map := ReferenceMap.new(map,Vector2(params.x,params.y),2)
	run_conversion_tests(refrence_map, params)
	map.tile_map.free()

func generate_conversion_paramaters() -> Dictionary:
	var out := []
	for x in tests_map.SIZE.x:
		for y in tests_map.SIZE.y:
			out.append([x,y])
	return ParameterFactory.named_parameters(["x","y"],out)

func generate_conversion_paramater_description(params) -> String:
	return "with a start tile of " + str(Vector2(params.x,params.y))

func run_conversion_tests(refrence_map : ReferenceMap, params):
	for x in tests_map.SIZE.x:
		for y in tests_map.SIZE.y:
			run_conversion_test(Vector2(x,y), refrence_map, params)

func run_conversion_test(cell : Vector2, refrence_map : ReferenceMap , params):
	var refrenced_cell := cell - refrence_map.refrence_rect.position
	assert_eq(refrenced_cell, refrence_map.map_to_internal_map(cell), "Refrence map to map correct at " + str(cell) + generate_conversion_paramater_description(params))
	assert_eq(cell, refrence_map.internal_map_to_map(refrenced_cell), "Internal map to map correct at " + str(cell) + generate_conversion_paramater_description(params))
