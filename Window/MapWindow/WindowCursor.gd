extends Control

var cell : Vector2

func _gui_input(event):
	if "position" in event:
		var map = get_parent().map
		cell = MapSpaceConverter.local_to_map(event.position - $TilemapContainer.position,map)
		if Pathfinder.is_walkable(cell,map):
			$TilemapContainer/ArrowLines.draw_path(cell)
		else:
			$TilemapContainer/ArrowLines.clear()
