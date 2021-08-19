extends "res://addons/gut/test.gd"

var map : Map

func before_each():
	map = Map.new(autofree(TileMap.new()))
	map.add_person(Person.new(Character.new()))

func test_get_movement_window():
	assert_has_method(map,"get_window")
	if map.has_method("get_window"):
		var parent = add_child_autofree(Node2D.new())
		var movement_window = autofree(map.get_window(Vector2.ZERO,parent,false))
		assert_not_null(movement_window)
		assert_eq(movement_window, autofree(map.get_window(Vector2.ZERO, parent)))
