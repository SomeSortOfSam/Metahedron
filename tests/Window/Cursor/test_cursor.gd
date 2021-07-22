extends "res://addons/gut/test.gd"

var tile_map := TileMap.new()
var map : Map
var cursor : Cursor

func before_all():
	add_child(tile_map)
	for x in 3:
		for y in 3:
			tile_map.set_cell(x,y,0)
	map = Map.new(tile_map)
	cursor = Cursor.new(map)

func before_each():
	cursor.cell = Vector2.ZERO

func test_initialization():
	cursor.free()
	cursor = Cursor.new(map)
	assert_eq(cursor.modulate, Color(1,1,1,0), "Cursor starts clear")

func test_set_cell():
	cursor.cell = Vector2.ONE
	assert_eq(cursor.cell, Vector2.ONE, "Cursor cell can be set")
	cursor.cell = Vector2.RIGHT
	assert_eq(cursor.cell, Vector2.RIGHT, "Cursor cell can change")
	cursor.cell = Vector2.UP
	assert_eq(cursor.cell, Vector2.ZERO, "Cursor cell is clamped")
	assert_eq(map.map_to_world(cursor.cell),cursor.position, "Cursor cell and position are linked")

func test_mouse_movement():
	var event := InputEventMouseMotion.new()
	var new_pos := map.map_to_world(Vector2.ONE)
	event.position = new_pos
	cursor._input(event)
	assert_eq(cursor.position, new_pos, "Mouse movement sets cell")
	
	event.position = map.map_to_world(Vector2(0,-1))
	cursor._input(event)
	assert_eq(cursor.modulate,Color(1,1,1,0), "Out of bounds mouse hides cursor")
	
	event.position = map.map_to_world(Vector2.ZERO)
	cursor._input(event)
	assert_eq(cursor.modulate,Color.white, "In bounds mouse reveals cursor")

func test_keyboard_movement():
	var old_pos := cursor.position
	cursor._input(FakeInput.new(["ui_down"]))
	assert_ne(old_pos, cursor.position, "Keyboard movement sets cell")
	
	cursor.cell = Vector2.ZERO
	cursor._input(FakeInput.new(["ui_up"]))
	assert_eq(cursor.cell, Vector2.ZERO, "Keyboard movement is clamped")
	
	var extended_tile_map := TileMap.new()
	for x in 3:
		for y in 3:
			extended_tile_map.set_cell(x,y,0)
	extended_tile_map.set_cell(0,2,0)
	add_child_autofree(extended_tile_map)
	var extended_map := Map.new(extended_tile_map)
	var extended_cursor := Cursor.new(extended_map)
	extended_cursor.cell = Vector2(1,2)
	extended_cursor._input(FakeInput.new(["ui_down"]))
	assert_eq(extended_cursor.cell, Vector2(1,2), "Keyboard does not move off walkable tiles")
	extended_cursor.free()
	extended_map.tile_map.free()

func test_mouse_click():
# warning-ignore:return_value_discarded
	cursor.connect("accept_pressed", self, "mouse_click_return")
	cursor._input(FakeInput.new(["ui_accept"]))

func mouse_click_return(cell):
	assert_eq(cell, Vector2.ZERO, "Click accpeted")
	assert_ne(cursor.modulate.a,1.0)

class FakeInput extends Reference:
	var is_echo : bool
	var true_actions := []
	
	func _init(new_true_actions : Array, new_is_echo : bool = false):
		true_actions = new_true_actions
		is_echo = new_is_echo
	
	func is_pressed() -> bool:
		return true_actions.size() > 0
	
	func is_action(fake_action : String) -> bool:
		return true_actions.find(fake_action) != -1
	
	func is_action_pressed(fake_action : String) -> bool:
		return is_action(fake_action)
	
# warning-ignore:function_conflicts_variable
	func is_echo():
		return is_echo

func test_z_index():
	var unit := Unit.new()
	add_child_autofree(unit)
	assert_gt(unit.z_index,cursor.z_index)

func after_all():
	cursor.free()
	map.tile_map.free()
