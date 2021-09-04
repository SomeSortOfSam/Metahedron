extends "res://addons/gut/test.gd"

var map : Map

func before_each():
	map = Map.new(autofree(TileMap.new()))
	map.add_person(Person.new(Character.new()))

func test_get_movement_window():
	var person = map.people[Vector2.ZERO]
	if assert_has_method(person,"initialize_window"):
		var window = person.initialize_window()
		assert_eq(person.window,window,"Window is cached")
