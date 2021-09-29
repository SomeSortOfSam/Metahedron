extends "res://addons/gut/test.gd"

var refrence_tilemap 

func test_new_refrence_map():
	var refrence_map := initialize_refrence_map()
	
	assert_eq(refrence_tilemap,refrence_map.tile_map,"Tilemap is assigned")
	assert_eq(refrence_map.people.size(),1, "Has correct number of units")

func initialize_refrence_map() -> ReferenceMap:
	refrence_tilemap = add_child_autofree(TileMap.new()) as TileMap
	var map := MapTestUtilites.initalize_full_map()
	autofree(map.tile_map)
	map.add_person(Person.new(Character.new()))
	var person := Person.new(Character.new())
	map.add_person(person)
	person.cell = Vector2.ONE * 3
	map.tile_map.name = "Map Tilemap"
	refrence_tilemap.name = "Refrence Map Tilemap"
	return ReferenceMap.new(refrence_tilemap,map,Vector2.ZERO,2)
