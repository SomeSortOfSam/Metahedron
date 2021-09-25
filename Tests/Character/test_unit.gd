extends "res://addons/gut/test.gd"

var unit : Unit

func before_all():
	unit = Unit.new()
	add_child(unit)

func test_in_level_map():
	unit.is_icon = true
	
	assert_false(unit._sprite.visible)
	assert_true(unit._icon.visible)
	
	unit.is_icon = false
	
	assert_true(unit._sprite.visible)
	assert_false(unit._icon.visible)

func test_set_character():
	var character = Character.new()
	character.icon = load("res://Map/Character/Jean/8Ball.png")
	character.icon_offset = Vector2.ONE
	character.animations_offset = Vector2.DOWN
	
	unit.character = character
	
	assert_eq(unit._icon.position,character.icon_offset, "Unit uses icon offset")
	assert_eq(unit._icon.texture,character.icon,"Unit uses icon")
	assert_eq(unit._sprite.position,character.animations_offset,"Unit uses animation offset")

func test_tile_snap():
	unit.override_in_editor = true
	
	unit.position = Vector2.ZERO
	assert_eq(Vector2.ZERO,unit.position,"Position does not change when parent is not tilemap")
	
	unit.position = Vector2.ZERO
	var tilemap := setup_tilemap()
	unit.notification(2000)
	assert_ne(Vector2.ZERO,unit.position,"Position adjusts when parent is tilemap. Cell size " + str(tilemap.cell_size))
	
	unit.override_in_editor = false
	
	tilemap.remove_child(unit)
	add_child(unit)

func setup_tilemap() -> TileMap:
	var tilemap := TileMap.new()
	add_child_autofree(tilemap)
	remove_child(unit)
	tilemap.add_child(unit)
	return tilemap

func after_all():
	unit.free()
