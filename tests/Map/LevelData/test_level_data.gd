extends "res://addons/gut/test.gd"

var level_data : LevelData

func before_each():
	level_data = LevelData.new()
	add_child_autofree(level_data)

func test_to_map():
	level_data.add_unit(Vector2.ZERO)
	var map := level_data.to_map()
	assert_is(map, Map)
	assert_eq_deep(map.tile_map,level_data)
	assert_has(map.units,Vector2.ZERO)

func test_initalization():
	assert_is(level_data,TileMap)

func test_add_unit():
	assert_has_method(level_data,"add_unit")
	level_data.add_unit(Vector2.ZERO)
	assert_eq(level_data.get_child_count(),1)
	var unit := level_data.get_child(0) as Unit
	assert_eq(unit.position, Vector2.ZERO)
