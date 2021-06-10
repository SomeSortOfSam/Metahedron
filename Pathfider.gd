extends Reference
class_name Pathfinder

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _map : Resource
var _astar := AStar2D.new()

func _init(map : Map, walkable_cells : Array):
	_map = map
	
	var cell_mappings := {}
	for cell in walkable_cells:
		cell_mappings[cell] = _map.map_to_map_index(cell)
	
	_add_and_connect_points(cell_mappings)

func calculate_point_path(start: Vector2, end: Vector2) -> PoolVector2Array:
	var start_index : int = _map.map_to_map_index(start)
	var end_index : int = _map.map_to_map_index(end)
	
	if not _astar.has_point(start_index) or not _astar.has_point(end_index):
		return PoolVector2Array()
	else:
		return _astar.get_point_path(start_index,end_index)

func _add_and_connect_points(cell_mappings: Dictionary):
	for point in cell_mappings:
		_astar.add_point(cell_mappings[point], point)
	
	for point in cell_mappings:
		for neighor_index in _find_unconnected_neighbor_indices(point, cell_mappings):
			_astar.connect_points(cell_mappings[point], neighor_index)

func _find_unconnected_neighbor_indices(cell: Vector2, cell_mappings: Dictionary) -> Array:
	var out := []
	for direction in DIRECTIONS:
		var neighbor: Vector2 = cell + direction
		if not cell_mappings.has(neighbor):
			continue
		
		if not _astar.are_points_connected(cell_mappings[cell], cell_mappings[neighbor]):
			out.push_back(cell_mappings[neighbor])
		
	return out
