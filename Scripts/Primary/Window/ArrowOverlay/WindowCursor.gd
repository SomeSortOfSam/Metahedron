extends Control
class_name WindowCursor

onready var container : Node2D = $TilemapContainer
onready var arrow_lines : ArrowLines = $TilemapContainer/ArrowLines

var map : ReferenceMap setget set_map

signal path_accepted(path)

func _gui_input(event):
	if "position" in event:
		var cell := position_to_cell(event.position)
		if is_cell_acceptable(cell):
			handle_acceptable_cell(cell, event)
		else:
			arrow_lines.clear()

func handle_acceptable_cell(cell : Vector2, event):
	var path = arrow_lines.draw_path(cell)
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.pressed:
		emit_signal("path_accepted", path)

func is_cell_acceptable(cell : Vector2):
	var out := Pathfinder.is_walkable(cell,map)
	out = out && Pathfinder.is_cell_in_range(Vector2.ZERO,cell,map.tile_range)
	out = out && !Pathfinder.is_occupied(cell,map)
	out = out && Pathfinder.is_path_walkable(cell,map)
	return out 

func position_to_cell(pos : Vector2) -> Vector2:
	var tilemap_container : Node2D = $TilemapContainer
	var local_position : Vector2 =(pos - tilemap_container.position) / tilemap_container.scale
	return MapSpaceConverter.local_to_map(local_position,map)

func set_map(new_map : ReferenceMap):
	map = new_map
	regenerate_astar()
	var _connection = map.connect("position_changed", self, "regenerate_astar")

func regenerate_astar():
	arrow_lines.astar = Pathfinder.refrence_map_to_astar(map)

func disable():
	arrow_lines.hide()
