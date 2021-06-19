extends WAT.Test

func test_empty_map_tests():
	describe("New empty Map")
	
	var map := Map.new()
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_equal(map.rect.size,Vector2.ZERO,"map size is zero")

func test_3x3_map_tests():
	var size := Vector2.ONE * 3
	
	describe("New " + str(size) + " Map")
	var map := initialize_full_tilemap(size)
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_equal(map.rect.size,size,"map size is " + str(size))

func test_unscaled_untransformed_conversions():
	describe("Unscaled, untransformed convertions")
	
	var map := initialize_full_tilemap(Vector2.ONE * 5)
	
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			asserts.is_equal(map.world_to_map(Vector2(x,y)),Vector2(x,y),"World to Map convertion at " + str(Vector2(x,y)) + " returns same vector")
			asserts.is_equal(map.map_to_world(Vector2(x,y)),Vector2(x,y),"Map to World convertion at " + str(Vector2(x,y)) + " returns same vector")

func test_scaled_untransformed_conversions():
	describe("Scaled x3, untransformed convertions")
	
	var map := initialize_full_tilemap(Vector2.ONE * 5, Vector2.ZERO, Vector2.ONE*3)
	
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			asserts.is_equal(map.world_to_map(Vector2(x*3,y*3)),Vector2(x,y),"World to Map convertion at " + str(Vector2(x,y)) + " returns scaled vector")
			asserts.is_equal(map.map_to_world(Vector2(x,y)),Vector2(x*3,y*3),"Map to World convertion at " + str(Vector2(x,y)) + " returns scaled vector")

func test_unscaled_transformed_conversions():
	describe("Unscaled, transformed (3,3) convertions")
	
	var map := initialize_full_tilemap(Vector2.ONE * 5, Vector2.ONE * 3)
	
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			asserts.is_equal(map.world_to_map(Vector2(x + 3,y + 3)),Vector2(x,y),"World to Map convertion at " + str(Vector2(x,y)) + " returns transformed vector")
			asserts.is_equal(map.map_to_world(Vector2(x,y)),Vector2(x + 3,y + 3),"Map to World convertion at " + str(Vector2(x,y)) + " returns transformed vector")

func test_scaled_transformed_conversions():
	describe("Scaled x3, transformed (3,3) convertions")
	
	var map := initialize_full_tilemap(Vector2.ONE * 5, Vector2.ONE *3, Vector2.ONE *3)
	
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			asserts.is_equal(map.world_to_map(Vector2((x+3)*3,(y+3)*3)),Vector2(x,y),"World to Map convertion at " + str(Vector2(x,y)) + " returns scaled, transformed vector")
			asserts.is_equal(map.map_to_world(Vector2(x,y)),Vector2((x+3)*3,(y+3)*3),"Map to World convertion at " + str(Vector2(x,y)) + " returns scaled, transformed vector")

func initialize_full_tilemap(size : Vector2, offset : Vector2 = Vector2.ZERO, tile_scale : Vector2 = Vector2.ONE) -> Map:
	var tilemap := TileMap.new()
	tilemap.cell_size = tile_scale
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(x + offset.x,y + offset.y,0)
	return Map.new(tilemap)
