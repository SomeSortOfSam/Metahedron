extends "res://addons/gut/test.gd"

var movement_window : MovementWindow

func test_populate(params = use_parameters(MapTestUtilites.get_map_params())):
	setup_movement_window(params)
	movement_window.map.repopulate_displays()
	assert_ne(movement_window.map.tile_map.get_cell(0,0),-1,"Tilemap is filled" + MapTestUtilites.get_parameter_description(params))
	assert_gt(movement_window.map.tile_map.get_child_count(),1, "Unit and decoration exist")

func test_position(params = use_parameters(MapTestUtilites.get_map_params())):
	setup_movement_window(params)
	movement_window.popup_around_tile()
	var tile_pos = MapSpaceConverter.map_to_global(Vector2.ZERO,movement_window.map)
	var internal_tile_pos = MapSpaceConverter.map_to_global(Vector2.ZERO,movement_window.map.map)
	assert_almost_eq(tile_pos,internal_tile_pos, Vector2.ONE * .1)

func setup_movement_window(params):
	var parent = add_child_autofree(Node2D.new())
	var map := MapTestUtilites.params_to_map(params, parent)
	map.add_person(Person.new(Character.new()))
	map.add_decoration(DecorationInstance.new(DecorationDefinition.new()))
	movement_window = add_child_autofree(MovementWindow.get_window(Vector2.ZERO, map, 2)) as MovementWindow


