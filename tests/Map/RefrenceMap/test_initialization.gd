extends "res://addons/gut/test.gd"

var refrence_tilemap 

func test_new_refrence_map():
	var refrence_map := initialize_refrence_map()
	
	assert_eq(refrence_tilemap,refrence_map.tile_map,"Tilemap is assigned")

func initialize_refrence_map() -> ReferenceMap:
	refrence_tilemap = add_child_autofree(TileMap.new()) as TileMap
	var map := Map.new(add_child_autofree(TileMap.new()))
	map.tile_map.name = "Map Tilemap"
	refrence_tilemap.name = "Refrence Map Tilemap"
	return ReferenceMap.new(refrence_tilemap,map,Vector2.ZERO,3)
