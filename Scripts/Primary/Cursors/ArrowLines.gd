extends TileMap
class_name ArrowLines, "res://Assets/Editor Icons/Arrowlines.png"
## A cursor for WindowDursor that draws a pathfound line

var astar : AStar2D

func draw_display(to : Vector2, acceptable : bool):
	clear()
	if acceptable:
		var path := astar.get_point_path(MapSpaceConverter.map_to_index(Vector2.ZERO),MapSpaceConverter.map_to_index(to))
		for point in path:
			set_cellv(point,0)
		update_bitmask_region()
		set_cell(0,0,0,false,false,false,Vector2.ZERO) #set center cell to non arrow

func _on_map_change(map):
	astar = map.astar
