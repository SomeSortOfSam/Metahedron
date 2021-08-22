extends "res://addons/gut/test.gd"

func test_conversions(params = use_parameters(MapTestUtilites.get_map_params())):
	var map := MapTestUtilites.params_to_map(params,add_child_autofree(Node2D.new()))
	var used_rect := map.get_used_map_rect()
	for x in used_rect.size.x:
		for y in used_rect.size.y:
			run_conversion_test(map, Vector2(x,y), params)

func run_conversion_test(map : Map, map_point : Vector2, params):
	var world_point := map.tile_map.map_to_world(map_point + map.get_used_map_rect().position) * map.tile_map.scale + map.tile_map.global_position 
	world_point += (map.tile_map.cell_size * map.tile_map.scale)/2
	assert_eq(map.global_to_map(world_point),map_point,"World to Map convertion at " + str(map_point) + MapTestUtilites.get_parameter_description(params))
	assert_eq(map.map_to_global(map_point),world_point,"Map to World convertion at " + str(map_point) + MapTestUtilites.get_parameter_description(params))

func test_clamp():
	var map := MapTestUtilites.initalize_full_map()
	var used_rect := map.get_used_map_rect()
	for x in range(-1,used_rect.size.x + 1):
		for y in range(-1,used_rect.size.y + 1):
			var cell := Vector2(x,y)
			var clamped_cell = map.clamp(cell)
			if map.is_walkable(cell):
				assert_eq(cell,clamped_cell, "In bounds point remains constant at " + str(cell))
			else:
				assert_ne(cell, clamped_cell, "Out of bounds point changes at " + str(cell))
				assert_true(map.is_walkable(clamped_cell), "New cell " + str(clamped_cell) +" in bounds at " + str(cell))
	
	map.tile_map.free()

func test_get_rect(params = use_parameters(MapTestUtilites.get_map_params())):
	var map := MapTestUtilites.params_to_map(params,add_child_autofree(Node2D.new()))
	var map_rect := map.get_used_map_rect()
	var local_rect := map.get_used_local_rect()
	assert_eq(local_rect.size,map_rect.size *3 * map.tile_map.cell_size * map.tile_map.scale )
	pending()
