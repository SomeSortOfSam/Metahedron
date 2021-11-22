extends TileMap
class_name AttackRenderer

var attack : Attack

func _ready():
	add_to_group("displays")

func draw_display(_to : Vector2, acceptable : bool):
	if acceptable and attack:
		for cell in attack.attack(null, Vector2.ZERO, Vector2.ONE):
			set_cellv(cell,0)
		for display in get_tree().get_nodes_in_group("displays"):
			display.attack = attack
	

func _on_map_change(_map):
	pass
