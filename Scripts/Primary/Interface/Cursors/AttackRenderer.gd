extends TileMap
class_name AttackRenderer

var attack : Attack
var center_cell : Vector2

func draw_display(_to : Vector2, acceptable : bool):
	if acceptable:
		print(center_cell)
		for cell in attack.attack(null, Vector2.ZERO, Vector2.ONE, center_cell):
			set_cellv(cell,0)
	
func set_center_cell(map : ReferenceMap):
	center_cell = map.center_cell

func _on_map_change(_map):
	pass
