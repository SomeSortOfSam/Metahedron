extends "res://addons/gut/test.gd"

func test_character_initialization():
	var character = Character.new()
	assert_not_null(character, "Character exists")
