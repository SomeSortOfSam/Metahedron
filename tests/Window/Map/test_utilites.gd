extends "res://addons/gut/test.gd"

func test_empty_centering():
	assert_eq(TileMapUtilites.get_centered_position(Map.new(autofree(TileMap.new())),Vector2.ONE * 6), Vector2.ONE * 3)
	
func test_centering(params = use_parameters(MapTestUtilites.get_map_params())):
	var parent = add_child_autofree(Node2D.new())
	var map = MapTestUtilites.params_to_map(params,parent)
	map.tile_map.position = TileMapUtilites.get_centered_position(map, Vector2.ONE * 9)
	var center_tile = (map.get_used_map_rect().size/2).floor()
	var center_tile_position = map.map_to_global(center_tile)
	assert_eq(center_tile_position, parent.position + Vector2.ONE*9*.5/parent.scale, MapTestUtilites.get_parameter_description(params))
