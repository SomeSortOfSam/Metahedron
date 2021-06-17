extends TileMap
class_name UnitOverlay

export var map : Resource

func draw(cells: Array):
	clear()
	for cell in cells:
		set_cellv(cell + map.map_rect.position, 0)
