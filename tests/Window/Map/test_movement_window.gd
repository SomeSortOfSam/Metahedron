extends "res://addons/gut/test.gd"

var movement_window : MovementWindow

func test_populate(params = use_parameters(MapTestUtilites.get_map_params())):
	setup_movement_window(params)
	assert_ne(movement_window.map.tile_map.get_cell(0,0),-1,"Tilemap is filled" + MapTestUtilites.get_parameter_description(params))
	assert_gt(movement_window.map.tile_map.get_child_count(),1, "Unit and decoration exist")

func test_size():
	pending()

func test_position(params = use_parameters(MapTestUtilites.get_map_params())):
	setup_movement_window(params)
	assert_eq(movement_window.map.map_to_global(Vector2.ZERO),movement_window.map.map.map_to_global(Vector2.ZERO))

func setup_movement_window(params):
	var parent = add_child_autofree(Node2D.new())
	var map := MapTestUtilites.params_to_map(params, parent)
	var unit = Person.new(Character.new(),map)
	map.add_person(unit)
	var _decoration
	map.add_decoration()
	movement_window = add_child_autofree(MovementWindow.get_window(Vector2.ZERO, map, 2, false)) as MovementWindow
	