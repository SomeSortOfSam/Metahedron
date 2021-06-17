extends TileMap
class_name Unit_Path

export var map : Resource

var _pathfinder : Pathfinder
var current_path := PoolVector2Array()

func initialize(walkable_cells : Array):
	_pathfinder = Pathfinder.new(map, walkable_cells)

func draw(cell_start: Vector2, cell_end: Vector2):
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	
	for cell in current_path:
		set_cellv(cell, 0)
	
	update_bitmask_region() #enable autotile

func stop():
	_pathfinder = null
	clear()
