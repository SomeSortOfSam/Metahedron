extends Reference
class_name Person

var character : Character
export var cell : Vector2 setget set_cell
var window

signal cell_change(cell)

func _init(new_character : Character):
	character = new_character

func set_cell(new_cell : Vector2):
	cell = new_cell
	print(str(cell.x) + ", " + str(cell.y))
	emit_signal("cell_change",cell)
	
func move_cell(offset : Vector2):
	cell += offset
	print(str(cell.x) + ", " + str(cell.y))
	emit_signal("cell_change", offset)
	move_window()

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.get_node("Control").connect("cell_selected", self, "move_cell")
	if window.get_node("Control") == null:
		print("Unable to connect Person.gd to WindowCursor.gd")
	return window
	
func move_window() -> MovementWindow:
	var tile_map = window.get_node("Control/TilemapContainer/TileMap") as TileMap
	var map = ReferenceMap.new(tile_map, Map.new(tile_map), cell, 3)
	window = MovementWindow.get_window(cell,map,3)
	window.get_node("Control").connect("cell_selected", self, "move_cell")
	if window.get_node("Control") == null:
		print("Unable to connect Person.gd to WindowCursor.gd")
	#window.popup_around_tile() 
	return window

func to_unit(map, icon):
	var unit := Unit.new()
	unit.set_person(self)
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	unit._sprite.playing = true
