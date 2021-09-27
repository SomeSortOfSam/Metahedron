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
	emit_signal("cell_change",cell)

func initialize_window(map) -> MovementWindow:
	window = MovementWindow.get_window(cell,map,3)
	window.get_node("Control").connect("cell_selected", self, "move_cell")
	if window.get_node("Control") == null:
		print(":(")
	return window

func to_unit(map, icon):
	var unit := Unit.new()
	map.tile_map.add_child(unit)
	unit.subscribe(self,map)
	unit.is_icon = icon
	unit._sprite.playing = true
