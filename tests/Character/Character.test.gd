extends WAT.Test

func test_character_initialization():
	var character = Character.new()
	asserts.is_not_null(character, "Character exists")
	asserts.is_null(character.sprite, "Character has sprite slot")
