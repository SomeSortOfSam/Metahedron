extends "res://addons/gut/test.gd"
class_name MapTestUtilites

const SIZE := Vector2.ONE * 3
const PARAM_NAMES := ["cell_size","cell_offset","object_scale","object_offset", "parent_scale", "parent _offset"]
const DEFAULT_PARAMS := [Vector2.ONE, Vector2.ZERO, Vector2.ONE, Vector2.ZERO, Vector2.ONE, Vector2.ZERO]

func test_empty_map_tests():
	var map := Map.new(TileMap.new())
	
	assert_not_null(map,"Map is created")
	assert_not_null(map.people, "Map has people dictonary")
	assert_eq(map.get_used_rect().size,Vector2.ZERO,"map size is zero")
	assert_lt(map.people.size(), 1, "Map's units is empty")
	
	map.tile_map.free()

func test_populated_map_tests():
	var map := initalize_full_map()
	
	assert_not_null(map,"Map is created")
	assert_ne(map.get_used_rect(), Rect2(Vector2.ZERO,Vector2.ZERO), "Map has rect")
	assert_not_null(map.people, "Map has people dictonary")
	assert_eq(map.get_used_rect().size,SIZE,"map size is " + str(SIZE))
	assert_lt(map.people.size(), 1, "Map's units is empty")
	
	map.tile_map.free()

static func initalize_full_tilemap(size : Vector2 = SIZE , offset : Vector2 = Vector2.ZERO) -> TileMap:
	var tilemap := TileMap.new()
	for x in size.x:
		for y in size.y:
			tilemap.set_cell(x + offset.x,y + offset.y,0)
	return tilemap

static func initalize_full_map(size : Vector2 = SIZE , offset : Vector2 = Vector2.ZERO) -> Map:
	var map := Map.new(initalize_full_tilemap(size, offset))
	return map

static func get_map_params() -> Array:
	var out := []
	out.append(DEFAULT_PARAMS)
	for i in PARAM_NAMES.size():
		var new_params := [] + DEFAULT_PARAMS
		new_params[i] = Vector2.ONE * 3
		out.append(new_params)
	return out

static func get_parameter_description(params : Array) -> String:
	var description := " on a " + str(SIZE) + " map"
	var extras := " with "
	var use_extras := false
	for i in params.size():
		if params[i] != DEFAULT_PARAMS[i]:
			use_extras = true
			extras += PARAM_NAMES[i]
	if use_extras:
		description += extras
	return description

static func params_to_map(params : Array, parent : Node2D) -> Map:
	var map := initalize_full_map(SIZE,params[1])
	parent.add_child(map.tile_map)
	map.tile_map.cell_size = params[0]
	map.tile_map.scale = params[2]
	map.tile_map.position = params[3]
	parent.scale = params[4]
	parent.position = params[5]
	return map
	
