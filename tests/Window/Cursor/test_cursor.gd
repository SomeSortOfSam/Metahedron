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
	assert_eq(Pathfinder.map_to_world(map,cursor.cell),cursor.position, "Cursor cell and position are linked")

func test_mouse_movement():
	var event := FakeInput.new([],cursor)
	var new_pos := Vector2.ONE
	event.set_position(new_pos)
	cursor._input(event)
	assert_eq(cursor.cell, new_pos, "Mouse movement sets cell")
	
	event.set_position(Vector2(0,-1))
	cursor._input(event)
	assert_eq(cursor.modulate.a, 0.0, "Out of bounds mouse hides cursor")
	
	event.set_position(Vector2.ZERO)
	cursor._input(event)
	assert_eq(cursor.modulate.a, 1.0, "In bounds mouse reveals cursor")

func test_keyboard_movement():
	var old_pos := cursor.position
	cursor._input(FakeInput.new(["ui_down"], cursor))
	assert_ne(old_pos, cursor.position, "Keyboard movement sets cell")
	
	cursor.cell = Vector2.ZERO
	cursor._input(FakeInput.new(["ui_up"], cursor))
	assert_eq(cursor.cell, Vector2.ZERO, "Keyboard movement is clamped")
	
	var extended_cursor : Cursor = autofree(Cursor.new(setup_extend_map()))
	extended_cursor.cell = Vector2(1,2)
	extended_cursor._input(FakeInput.new(["ui_down"], extended_cursor))
	assert_eq(extended_cursor.cell, Vector2(1,2), "Keyboard does not move off walkable tiles")

func setup_extend_tilemap() -> TileMap:
	var extended_tile_map := TileMap.new()
	add_child_autofree(extended_tile_map)
	for x in 3:
		for y in 3:
			extended_tile_map.set_cell(x,y,0)
	extended_tile_map.set_cell(0,2,0)
	return extended_tile_map

func setup_extend_map() -> Map:
	var extended_tile_map := setup_extend_tilemap()
	return Map.new(extended_tile_map)

func test_mouse_click():
	
# warning-ignore:return_value_discarded
	cursor.connect("accept_pressed", self, "mouse_click_return")
	var input := FakeInput.new(["ui_accept"], cursor)
	input.set_position(Vector2(-1,0))
	cursor._input(input)

func mouse_click_return(cell):
	assert_eq(cell, Vector2.ZERO, "Click accpeted")
	assert_ne(cursor.modulate.a,1.0)

class FakeInput extends Reference:
	var is_echo : bool
	var is_position_override : bool = false
	var position_override : Vector2
	var true_actions := []
	var cursor : Cursor
	
	func _init(new_true_actions : Array, new_cursor : Cursor = cursor, new_is_echo : bool = false):
		cursor = new_cursor
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
	
	func set_position(value : Vector2):
		is_position_override = true
		position_override = value
	
	func get_position() -> Vector2:
		if is_position_override:
			return Pathfinder.map_to_world(cursor.map,position_override)
		return Pathfinder.map_to_world(cursor.map,cursor.cell)

func test_z_index():
	var unit := Unit.new()
	add_child_autofree(unit)
	assert_gt(unit.z_index ,cursor.z_index - 1)

func after_all():
	cursor.free()
	map.tile_map.free()
