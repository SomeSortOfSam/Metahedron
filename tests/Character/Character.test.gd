extends WAT.Test

func test_character_initialization():
	asserts.is_not_null(Character.new())
