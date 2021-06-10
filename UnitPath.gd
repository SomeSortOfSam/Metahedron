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

#temp
func _ready():
	var rect_start := Vector2(4,4)
	var rect_end := Vector2(10,8)
	
	var points := []
	
	for x in rect_end.x - rect_start.x + 1:
		for y in rect_end.y - rect_start.y + 1:
			points.append(rect_start + Vector2(x, y))
	
	# We can use the points to generate our PathFinder and draw a path.
	initialize(points)
	draw(rect_start, Vector2(8, 7))
