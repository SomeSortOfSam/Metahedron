extends "res://addons/gut/test.gd"

func test_no_enemies():
	#Arrange
	var map := Map.new(add_child_autofree(TileMap.new()))
	map.add_person(Person.new(Character.new()))
	map.add_person(Person.new(Character.new(),false,Vector2.ONE))
	watch_signals(map.people[Vector2.ZERO])
	#Act
	map.num_units_with_turn -= 2
	#Assert
	assert_signal_emitted(map.people[Vector2.ZERO],"new_turn")

func test_all_attacking():
	pending()

func test_all_skip():
	pending()
