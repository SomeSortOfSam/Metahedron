extends TileMap
class_name ArrowLines

var astar : AStar2D

func draw_display(to : Vector2, acceptable : bool) -> PoolVector2Array:
	clear()
	if acceptable:
		var path := astar.get_point_path(MapSpaceConverter.refrence_map_to_index(Vector2.ZERO),MapSpaceConverter.refrence_map_to_index(to))
		for point in path:
			set_cellv(point,0)
		update_bitmask_region()
		set_cell(0,0,0,false,false,false,Vector2.ZERO) #set center cell to non arrow
		return path
	else:
		return PoolVector2Array([])

func _on_map_change(map):
	astar = Pathfinder.refrence_map_to_astar(map)
