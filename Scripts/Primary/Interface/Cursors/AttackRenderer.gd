extends TileMap
class_name AttackRenderer

var attack : Attack

func draw_display(_to : Vector2, acceptable : bool):
	if acceptable:
		for cell in attack.attack(null, Vector2.ZERO, Vector2.ONE):
			set_cellv(cell,0)
	

func _on_map_change(_map):
	pass
