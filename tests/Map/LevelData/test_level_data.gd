extends "res://addons/gut/test.gd"

var level_data : LevelData

func before_each():
	level_data = LevelData.new()
	add_child_autofree(level_data)
	level_data.add_unit(Vector2.ZERO)
	level_data.to_map()

func test_to_map():
	var map = level_data.to_map()
	assert_eq(map.tile_map,level_data)
	assert_has(map.people,Vector2.ZERO)

func test_initalization():
	assert_is(level_data,TileMap)

func test_add_unit():
	assert_has_method(level_data,"add_unit")
	level_data.add_unit(Vector2.ZERO)
	assert_gt(level_data.get_child_count(),1)
	var unit := level_data.get_child(1) as Unit
	assert_eq(unit.position, Vector2.ZERO)

func test_get_movement_window():
	assert_has_method(level_data,"get_window")
	if level_data.has_method("get_window"):
		var movement_window = autofree(level_data.get_window(Vector2.ZERO, false))
		assert_not_null(movement_window)
		assert_eq_deep(movement_window, autofree(level_data.get_window(Vector2.ZERO)))
