extends WAT.Test

var size := Vector2.ONE * 3

func test_empty_map_tests():
	describe("New empty Map")
	
	var map := Map.new()
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_equal(map.rect.size,Vector2.ZERO,"map size is zero")

func test_3x3_map_tests():
	describe("New " + str(size) + " Map")
	var map := initialize_full_tilemap()
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_equal(map.rect.size,size,"map size is " + str(size))

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
	var description := "Conversions on a " + str(size) + " map"
	for i in params.size():
		if p[params[i]] != default[i]:
			description += " with " + params[i]
	return description

func generate_conversion_map() -> Map:
	var map := initialize_full_tilemap(p.cell_transform, p.cell_size)
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

func initialize_full_tilemap(offset : Vector2 = Vector2.ZERO, tile_scale : Vector2 = Vector2.ONE) -> Map:
	var tilemap := TileMap.new()
	tilemap.cell_size = tile_scale
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(x + offset.x,y + offset.y,0)
	return Map.new(tilemap)

func test_index_generation():
	var map := initialize_full_tilemap(size)
	var has_duplicate := false
	var checked := []
	for x in size.x:
		for y in size.y:
			var index := map.map_to_index(Vector2(x,y))
			has_duplicate = has_duplicate or checked.find(index) != -1
			checked.append(index)
	asserts.is_false(has_duplicate, "Does not create duplicates")