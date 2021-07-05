extends "res://addons/gut/test.gd"

var param_names := ["cell_size","cell_transform","object_size","object_transform"]
var default := [Vector2.ONE, Vector2.ZERO, Vector2.ONE, Vector2.ZERO]

func test_conversions(params = use_parameters(generate_conversion_paramaters())):
	var map := generate_conversion_map(params[0],params[1],params[2],params[3])
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			run_conversion_test(map, Vector2(x,y), params)

func generate_conversion_paramaters() -> Array:
	var out := []
	out.append(default)
	for i in param_names.size():
		var new_params := [] + default
		new_params[i] = Vector2.ONE * 3
		out.append(new_params)
	return out

func generate_conversion_parameter_description(params : Array) -> String:
	var description := " on a " + str(tests_map.SIZE) + " map"
	for i in params.size():
		if params[i] != default[i]:
			description += " with " + param_names[i]
	return description

func generate_conversion_map(cell_size : Vector2 = Vector2.ONE, cell_transform : Vector2 = Vector2.ZERO, \
object_size: Vector2 = Vector2.ONE, object_transform: Vector2 = Vector2.ZERO) -> Map:
	var map := tests_map.initalize_full_map(tests_map.SIZE, cell_transform, cell_size)
	map.tile_map.global_position = object_transform
	map.tile_map.scale = object_size
	map.tile_map.cell_tile_origin = TileMap.TILE_ORIGIN_CENTER
	return map

func run_conversion_test(map : Map, map_point : Vector2, params):
	var world_point := map.tile_map.map_to_world(map_point + map.rect.position) * map.tile_map.scale + map.tile_map.global_position 
	world_point += (map.tile_map.cell_size * map.tile_map.scale)/2
	assert_eq(map.world_to_map(world_point),map_point,"World to Map convertion at " + str(map_point) + generate_conversion_parameter_description(params))
	assert_eq(map.map_to_world(map_point),world_point,"Map to World convertion at " + str(map_point) + generate_conversion_parameter_description(params))

func test_clamp():
	var map := generate_conversion_map()
	for x in range(-1,map.rect.size.x + 1):
		for y in range(-1,map.rect.size.y + 1):
			var cell := Vector2(x,y)
			var clamped_cell = map.clamp(cell)
			if map.is_walkable(cell):
				assert_eq(cell,clamped_cell, "In bounds point remains constant at " + str(cell))
			else:
				assert_ne(cell, clamped_cell, "Out of bounds point changes at " + str(cell))
				assert_true(map.is_walkable(clamped_cell), "New cell in bounds at " + str(cell))
