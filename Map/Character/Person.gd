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

func initialize_window(map,popup):
	assert(false,"Sorry, but thats not implemented")
#	window = MovementWindow.get_window(cell,map,3,popup)
	pass
