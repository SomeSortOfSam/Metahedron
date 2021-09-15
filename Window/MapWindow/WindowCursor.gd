extends Control

var cell : Vector2

func _gui_input(event):
	if "position" in event:
		var map = get_parent().map
		cell = MapSpaceConverter.local_to_map(event.position - $TilemapContainer.position,map)
		if Pathfinder.is_walkable(cell,map) && Pathfinder.is_cell_in_range(Vector2.ZERO,cell,map.tile_range):
			$TilemapContainer/ArrowLines.draw_path(cell)
		else:
			$TilemapContainer/ArrowLines.clear()
