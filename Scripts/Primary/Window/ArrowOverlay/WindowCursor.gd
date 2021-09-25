extends Control

func _gui_input(event):
	if "position" in event:
		var map : ReferenceMap = get_parent().map
		var cell = position_to_cell(event.position, map)
		if is_cell_acceptable(cell,map):
			$TilemapContainer/ArrowLines.draw_path(cell)
		else:
			$TilemapContainer/ArrowLines.clear()

func is_cell_acceptable(cell : Vector2,map : ReferenceMap):
	return Pathfinder.is_walkable(cell,map) && Pathfinder.is_cell_in_range(Vector2.ZERO,cell,map.tile_range)

func position_to_cell(pos : Vector2, map : Map) -> Vector2:
	var tilemap_container : Node2D = $TilemapContainer
	var local_position : Vector2 =(pos - tilemap_container.position) / tilemap_container.scale
	return MapSpaceConverter.local_to_map(local_position,map)
