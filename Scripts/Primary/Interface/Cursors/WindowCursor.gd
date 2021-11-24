extends Control
class_name WindowCursor,"res://Assets/Editor Icons/WindowCursor.png"
## GUI that takes control inputs and gives tilemap outputs, with optional cursor Node2D for feedback

export var display_path : NodePath

onready var display : Node2D = get_node(display_path)

var map : Map setget set_map
var enabled := true setget enable

signal position_accepted(cell)

func _gui_input(event):
	if "position" in event && map && display && enabled:
		var cell := position_to_cell(event.position)
		var acceptable := is_cell_acceptable(cell)
		handle_cell(cell,acceptable, event)

func handle_cell(cell : Vector2, acceptable : bool , event):
	if display:
		if display is AttackRenderer:
			for otherDisplay in get_tree().get_nodes_in_group(AttackRenderer.GROUP_NAME):
				otherDisplay.attack = display.attack
				otherDisplay.attack_center = display.map.center_cell
				otherDisplay.draw_display(cell, acceptable)
		else:
			display.draw_display(cell, acceptable)
	if is_accepted(acceptable, event):
		emit_signal("position_accepted", cell)

func is_cell_acceptable(cell : Vector2) -> bool:
	var out := Pathfinder.is_walkable(cell,map)
	if "map" in map:
		out = out && Pathfinder.is_cell_in_range(Vector2.ZERO,cell,map.tile_range)
	if display is ArrowLines:
		out = out && !Pathfinder.is_occupied(cell,map)
		out = out && Pathfinder.is_path_walkable(cell,map)
	return out 

func is_accepted(acceptable,event):
	acceptable = acceptable && event is InputEventMouseButton
	acceptable = acceptable && event.button_index == BUTTON_LEFT
	acceptable = acceptable && event.pressed
	return acceptable

func position_to_cell(pos : Vector2) -> Vector2:
	var container : Node2D = map.tile_map.get_parent()
	var local_position : Vector2 = (pos - container.position) / container.scale
	return MapSpaceConverter.local_to_map(local_position,map)

func set_map(new_map : Map):
	map = new_map
	display._on_map_change(map)
	if map is ReferenceMap:
		var _connection = map.connect("position_changed", display, "_on_map_change",[map])

func enable(new_enabled : bool):
	enabled = new_enabled
	display.set_visible(new_enabled)

func _on_Body_mouse_exited():
	handle_cell(Vector2.ZERO,false,null)
