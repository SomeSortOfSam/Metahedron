extends "res://addons/gut/test.gd"

func test_populate_tilemap(params = use_parameters(MapTestUtilites.get_map_params())):
	var parent = add_child_autofree(Node2D.new())
	var map := MapTestUtilites.params_to_map(params, parent)
	var movement_window := add_child_autofree(MovementWindow.get_window(Vector2.ZERO, map, 2)) as MovementWindow
	
	assert_ne(movement_window.map.tile_map.get_cell(0,0),-1,"Tilemap is filled" + MapTestUtilites.get_parameter_description(params))

func test_size():
	pending()

func test_position():
	pending()
