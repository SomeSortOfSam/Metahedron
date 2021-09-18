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
	emit_signal("cell_change",cell)

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	return window

func to_unit(map, icon):
	var unit := Unit.new()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	unit._sprite.playing = true
