extends "res://addons/gut/test.gd"

var map : Map

func before_each():
	map = Map.new(add_child_autofree(TileMap.new()))

func test_populate_people():
	if assert_true("people" in map,"Map has a people field"):
		assert_typeof(map.people,TYPE_DICTIONARY,"Map.people is dictonary")
		var character = Character.new()
		map.people[Vector2.ZERO] = Person.new(character)
		map.populate_units()
		assert_gt(map.tile_map.get_child_count(),0,"Map is populated by something")
		assert_eq((map.tile_map.get_child(0) as Unit).character, character, "Map is populated by unit with correct character")

func test_populate_decorations():
	if assert_true("decorations" in map,"Map has a decorations field"):
		assert_typeof(map.people,TYPE_ARRAY,"Map.people is array")
		var definiton = DecorationDefinition.new()
		map.decorations.append(DecorationInstance.new(definiton))
		map.populate_decoration_displays()
		assert_gt(map.tile_map.get_child_count(),0,"Map is populated by something")
		assert_eq((map.tile_map.get_child(0) as DecorationDisplay).definition, definiton, "Map is populated by Decoration with correct Definition")

func get_refrence_map() -> ReferenceMap:
	return ReferenceMap.new(add_child_autofree(TileMap.new()), map, Vector2.ZERO, 1)

func populate_map_with_tiles():
	map.tile_map.set_cell(0,0,0)
	map.tile_map.set_cell(1,0,0)
	map.tile_map.set_cell(2,0,0)

func test_refrence_map_populate_tiles():
	populate_map_with_tiles()
	var ref_map := get_refrence_map()
	ref_map.repopulate_tilemap()
	assert_eq(ref_map.tile_map.get_cell(0,0),0, "Tilemap center cell is populated")
	assert_eq(ref_map.tile_map.get_cell(1,0),0, "Tilemap neighbor cell is populated")
	assert_ne(ref_map.tile_map.get_cell(2,0),0, "Tilemap far cell is  not populated")

func populate_map_with_units():
	var person := Person.new(Character.new())
	person.cell = Vector2(0,0)
	map.people[Vector2(0,0)]=(person)
	person = Person.new(Character.new())
	person.cell = Vector2(1,0)
	map.people[Vector2(1,0)]=(person)
	person = Person.new(Character.new())
	person.cell = Vector2(2,0)
	map.people[Vector2(2,0)]=(person)

func populate_map_with_decorations():
	var decoration = DecorationInstance.new(DecorationDefinition.new())
	decoration.cell = Vector2(0,0)
	map.decorations.append(decoration)
	decoration = DecorationInstance.new(DecorationDefinition.new())
	decoration.cell = Vector2(1,0)
	map.decorations.append(decoration)
	decoration = DecorationInstance.new(DecorationDefinition.new())
	decoration.cell = Vector2(2,0)
	map.decorations.append(decoration)

func populate_map_fields():
	populate_map_with_units()
	populate_map_with_decorations()

func test_refrence_map_populate_fields():
	populate_map_fields()
	var ref_map := get_refrence_map()
	ref_map.repopulate_fields()
	assert_eq(ref_map.people.size(),2,"Map has correct number of people")
	assert_eq(ref_map.decorations.size(),2,"Map has correct number of Decorations")

func test_level_data_populate_fields():
	var level_data : LevelData = autofree(LevelData.new())
	var placeholder := Placeholder.new()
	placeholder.definition = Character.new()
	level_data.add_child(placeholder)
	placeholder = Placeholder.new()
	placeholder.definition = DecorationDefinition.new()
	level_data.add_child(placeholder)
	map = level_data.to_map()
	
	assert_eq(map.people.size(),1, "LevelData reads person")
	assert_eq(map.decorations.size(), 1, "LevelData reads Decorations")

