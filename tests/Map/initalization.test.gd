extends WAT.Test
class_name tests_map

const SIZE := Vector2.ONE * 3

func test_empty_map_tests():
	describe("New empty Map")
	
	var map := Map.new()
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_not_null(map.units, "Map has units dictonary")
	asserts.is_equal(map.rect.size,Vector2.ZERO,"map size is zero")
	asserts.is_empty(map.units, "Map's units is empty")

func test_populated_map_tests():
	describe("New " + str(SIZE) + " Map")
	var map := initialize_full_tilemap()
	
	asserts.is_not_null(map,"Map is created")
	asserts.is_not_null(map.rect, "Map has rect")
	asserts.is_not_null(map.units, "Map has units dictonary")
	asserts.is_equal(map.rect.size,SIZE,"map size is " + str(SIZE))
	asserts.is_empty(map.units, "Map's units is empty")

static func initialize_full_tilemap(size : Vector2 = SIZE , offset : Vector2 = Vector2.ZERO, tile_scale : Vector2 = Vector2.ONE) -> Map:
	var tilemap := TileMap.new()
	tilemap.cell_size = tile_scale
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(x + offset.x,y + offset.y,0)
	return Map.new(tilemap)


