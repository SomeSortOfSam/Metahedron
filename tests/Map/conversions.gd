extends WAT.Test

func test_conversions():
	var params := ["cell_size","cell_transform","object_size","object_transform"]
	var default := [Vector2.ONE, Vector2.ZERO, Vector2.ONE, Vector2.ZERO]
	parameters(generate_conversion_paramaters(params, default))
	describe(generate_conversion_description(params, default))
	run_conversion_tests(generate_conversion_map())

func generate_conversion_paramaters(params : Array, default : Array) -> Array:
	var out := []
	out.append(params)
	out.append(default)
	for i in params.size():
		var new_params := [] + default
		new_params[i] = Vector2.ONE * 3
		out.append(new_params)
	return out

func generate_conversion_description(params : Array, default : Array) -> String:
	var description := "Conversions on a " + str(tests_map.SIZE) + " map"
	for i in params.size():
		if p[params[i]] != default[i]:
			description += " with " + params[i]
	return description

func generate_conversion_map() -> Map:
	var map := tests_map.initialize_full_tilemap(tests_map.SIZE, p.cell_transform, p.cell_size)
	map.tile_map.position = p.object_transform
	map.tile_map.scale = p.object_size
	map.tile_map.cell_tile_origin = TileMap.TILE_ORIGIN_CENTER
	return map

func run_conversion_tests(map : Map):
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			run_conversion_test(map, Vector2(x,y))

func run_conversion_test(map : Map, map_point : Vector2):
	var world_point := map.tile_map.map_to_world(map_point + map.rect.position) * map.tile_map.scale + map.tile_map.position 
	world_point += map.tile_map.cell_size/2
	asserts.is_equal(map.world_to_map(world_point),map_point,"World to Map convertion at " + str(map_point))
	asserts.is_equal(map.map_to_world(map_point),world_point,"Map to World convertion at " + str(map_point))
