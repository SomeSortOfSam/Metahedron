extends "res://addons/gut/test.gd"

func test_empty_centering():
	assert_eq(TileMapUtilites.get_centered_position(add_child_autofree(TileMap.new()),Vector2.ONE * 6), Vector2.ONE * 3)

func test_centering(params = use_parameters(MapTestUtilites.get_map_params())):
	var parent = add_child_autofree(Node2D.new())
	var map = MapTestUtilites.params_to_map(params,parent)
	map.tile_map.position = TileMapUtilites.get_centered_position(map.tile_map, Vector2.ONE * 9)
	var center_tile = (map.tile_map.get_used_rect().size/2).floor()
	var center_tile_position = MapSpaceConverter.map_to_global(center_tile,map)
	assert_eq(center_tile_position, parent.position + Vector2.ONE*9*.5, MapTestUtilites.get_parameter_description(params))

func test_zoom():
	var map = MapTestUtilites.initalize_full_map()
	add_child_autofree(map.tile_map)
	var old_zoom = map.tile_map.scale.x
	var old_tile_pos = MapSpaceConverter.map_to_global(Vector2.ONE,map)
	
	TileMapUtilites.scale_around_tile(map.tile_map,Vector2.ONE*.5,MapSpaceConverter.map_to_tilemap(Vector2.ONE,map))
	assert_eq(old_tile_pos,MapSpaceConverter.map_to_global(Vector2.ONE,map), "Tile stays in postion on shrink")
	assert_lt(map.tile_map.scale.x, old_zoom, "Tilemap shrinks")
	old_zoom = map.tile_map.scale.x
	old_tile_pos = MapSpaceConverter.map_to_global(Vector2.ONE,map)
	
	TileMapUtilites.scale_around_tile(map.tile_map,Vector2.ONE*2,MapSpaceConverter.map_to_tilemap(Vector2.ONE,map))
	assert_gt(map.tile_map.scale.x, old_zoom, "Tilemap grows")
	assert_eq(old_tile_pos,MapSpaceConverter.map_to_global(Vector2.ONE,map), "Tile stays in position on grow")
