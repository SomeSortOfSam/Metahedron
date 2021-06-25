extends WAT.Test

var tile_map := TileMap.new()
var map : Map
var cursor : Cursor

func start():
	for x in 3:
		for y in 3:
			tile_map.set_cell(x,y,0)
	map = Map.new(tile_map)
	cursor = Cursor.new(map)

func pre():
	cursor.cell = Vector2.ZERO

func test_set_cell():
	describe("Set cell")
	
	cursor.cell = Vector2.ONE
	asserts.is_equal(cursor.cell, Vector2.ONE, "Cursor cell can be set")
	cursor.cell = Vector2.RIGHT
	asserts.is_equal(cursor.cell, Vector2.RIGHT, "Cursor cell can change")
	cursor.cell = Vector2.UP
	asserts.is_equal(cursor.cell, Vector2.ZERO, "Cursor cell is clamped")
	asserts.is_equal(map.map_to_world(cursor.cell),cursor.position, "Cursor cell and position are linked")

func test_mouse_movement():
	var event := InputEventMouseMotion.new()
	var new_pos := map.map_to_world(Vector2.ONE)
	event.position = new_pos
	cursor._input(event)
	asserts.is_equal(cursor.position, new_pos, "Mouse movement sets cell")
	
	event.position = map.map_to_world(Vector2.UP)
	cursor._input(event)
	asserts.is_equal(cursor.modulate,Color(1,1,1,0), "Out of bounds mouse hides cursor")
	
	event.position = map.map_to_world(Vector2.ZERO)
	cursor._input(event)
	asserts.is_equal(cursor.modulate,Color.white, "In bounds mouse reveals cursor")

func test_keyboard_movement():
	var old_pos := cursor.position
	cursor._input(FakeInput.new(["ui_down"]))
	asserts.is_not_equal(old_pos, cursor.position, "Keyboard movement sets cell")
	
	cursor.cell = Vector2.ZERO
	cursor._input(FakeInput.new(["ui_up"]))
	asserts.is_equal(cursor.cell, Vector2.ZERO, "Keyboard movement is clamped")
	
	var extended_tile_map := TileMap.new()
	for x in 3:
		for y in 3:
			extended_tile_map.set_cell(x,y,0)
	extended_tile_map.set_cell(0,2,0)
	var extended_map := Map.new(extended_tile_map)
	var extended_cursor := Cursor.new(extended_map)
	extended_cursor.cell = Vector2(1,2)
	extended_cursor._input(FakeInput.new(["ui_down"]))
	asserts.is_equal(extended_cursor.cell, Vector2(1,2), "Keyboard does not move off walkable tiles")

func test_mouse_click():
	cursor.connect("accept_pressed", self, "mouse_click_return")
	cursor._input(FakeInput.new(["ui_accept"]))

func mouse_click_return(cell):
	asserts.is_equal(cell, Vector2.ZERO, "Click accpeted")

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
	
	func is_echo():
		return is_echo
