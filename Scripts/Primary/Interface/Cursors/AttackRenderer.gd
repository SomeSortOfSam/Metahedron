extends TileMap
class_name AttackRenderer

var attack : Attack
var map : ReferenceMap

func _ready():
	add_to_group("displays")

func draw_display(_to : Vector2, acceptable : bool):
	if acceptable and attack:
		for cell in attack.attack(map, Vector2.ZERO, Vector2.ONE):
			set_cellv(MapSpaceConverter.internal_map_to_map(cell,map),0)
		for display in get_tree().get_nodes_in_group("displays"):
			display.attack = attack

func _on_map_change(new_map):
	map = new_map
