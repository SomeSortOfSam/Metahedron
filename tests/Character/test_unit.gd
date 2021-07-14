extends "res://addons/gut/test.gd"

const PATH =  "res://Character/Unit.tscn"
var unit : Unit

func before_all():
	var packedUnitScene := load(PATH)
	var unitScene = packedUnitScene.instance()
	unit = unitScene as Unit
	add_child(unitScene)

func test_in_level_map():
	unit.in_level_map = true
	
	assert_false(unit._sprite.visible)
	assert_true(unit._icon.visible)
	
	unit.in_level_map = false
	
	assert_true(unit._sprite.visible)
	assert_false(unit._icon.visible)

func test_set_character():
	var character = Character.new()
	character.icon = load("res://Character/Jean/8Ball.png")
	character.icon_offset = Vector2.ONE
	character.animations_offset = Vector2.DOWN
	
	unit.character = character
	
	assert_eq(unit._icon.position,character.icon_offset, "Unit uses icon offset")
	assert_eq(unit._icon.texture,character.icon,"Unit uses icon")
	assert_eq(unit._sprite.position,character.animations_offset,"Unit uses animation offset")

func test_draw():
	assert_has_method(unit, "_draw")
	
	var old_pos := unit.position
	unit._draw()
	assert_eq(old_pos,unit.position,"Position does not change when parent is not tilemap")
	
	unit.position = old_pos
	var tilemap := TileMap.new()
	add_child(tilemap)
	remove_child(unit)
	tilemap.add_child(unit)
	unit._draw(true)
	assert_ne(old_pos,unit.position,"Position adjusts when parent is tilemap. Cell size " + str(tilemap.cell_size))
	
	tilemap.remove_child(unit)
	add_child(unit)
	tilemap.free()

func after_all():
	unit.free()
