extends "res://addons/gut/test.gd"

const PATH =  "res://Character/Unit.tscn"
var unit : Unit

func before_all():
	var packedUnitScene := load(PATH)
	var unitScene = packedUnitScene.instance()
	unit = unitScene as Unit
	add_child(unitScene)

func test_initalization():
	assert_has_method(unit, "_draw")

func test_draw():
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
