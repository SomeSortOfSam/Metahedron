extends TileMap
class_name ArrowLines

var astar : AStar2D

func draw_path(to : Vector2):
	clear()
	var path := astar.get_point_path(MapSpaceConverter.refrence_map_to_index(Vector2.ZERO),MapSpaceConverter.refrence_map_to_index(to))
	for point in path:
		set_cellv(point,0)
