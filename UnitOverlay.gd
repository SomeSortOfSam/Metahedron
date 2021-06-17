extends TileMap
class_name UnitOverlay

func draw(cells: Array):
	clear()
	for cell in cells:
		set_cellv(cell, 0)
