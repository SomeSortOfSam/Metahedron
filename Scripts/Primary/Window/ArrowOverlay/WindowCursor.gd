extends Control

signal cell_selected(cell)
signal path_accepted(path)

func _gui_input(event):
	if "position" in event:
		var map : ReferenceMap = get_parent().get_parent().get_parent().map
		var cell := position_to_cell(event.position, map)
		if is_cell_acceptable(cell,map):
			var path = $TilemapContainer/ArrowLines.draw_path(cell)
			if event is InputEventMouseButton:
				if event.button_index == BUTTON_LEFT and event.pressed:
					emit_signal("cell_selected", cell)
					emit_signal("path_accepted", path)
		else:
			$TilemapContainer/ArrowLines.clear()

func is_cell_acceptable(cell : Vector2,map : ReferenceMap):
	var out := Pathfinder.is_walkable(cell,map)
	out = out && Pathfinder.is_cell_in_range(Vector2.ZERO,cell,map.tile_range)
	out = out && !Pathfinder.is_occupied(cell,map)
	out = out && Pathfinder.is_path_walkable(cell,map)
	return out 

func position_to_cell(pos : Vector2, map : Map) -> Vector2:
	var tilemap_container : Node2D = $TilemapContainer
	var local_position : Vector2 =(pos - tilemap_container.position) / tilemap_container.scale
	return MapSpaceConverter.local_to_map(local_position,map)
