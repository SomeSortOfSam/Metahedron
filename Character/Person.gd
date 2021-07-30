extends Reference
class_name Person

var character : Character
export var cell : Vector2 setget set_cell
var window

var map

signal cell_change(cell)

func _init(new_character : Character, new_map):
	character = new_character
	map = new_map

func set_cell(new_cell : Vector2):
	cell = map.clamp(new_cell)
	emit_signal("cell_change",cell)
