extends "res://addons/gut/test.gd"
class_name tests_map

const SIZE := Vector2.ONE * 3

func test_empty_map_tests():
	var map := Map.new()
	
	assert_not_null(map,"Map is created")
	assert_not_null(map.rect, "Map has rect")
	assert_not_null(map.units, "Map has units dictonary")
	assert_eq(map.rect.size,Vector2.ZERO,"map size is zero")
	assert_lt(map.units.size(), 1, "Map's units is empty")

func test_populated_map_tests():
	gut.p("New " + str(SIZE) + " Map")
	var map := initalize_full_map()
	
	assert_not_null(map,"Map is created")
	assert_not_null(map.rect, "Map has rect")
	assert_not_null(map.units, "Map has units dictonary")
	assert_eq(map.rect.size,SIZE,"map size is " + str(SIZE))
	assert_lt(map.units.size(), 1, "Map's units is empty")

static func initalize_full_tilemap(size : Vector2 = SIZE , offset : Vector2 = Vector2.ZERO, tile_scale : Vector2 = Vector2.ONE) -> TileMap:
	var tilemap := TileMap.new()
	tilemap.cell_size = tile_scale
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(x + offset.x,y + offset.y,0)
	return tilemap

static func initalize_full_map(size : Vector2 = SIZE , offset : Vector2 = Vector2.ZERO, tile_scale : Vector2 = Vector2.ONE) -> Map:
	var tilemap := initalize_full_tilemap(size, offset,tile_scale)
	return Map.new(tilemap)
