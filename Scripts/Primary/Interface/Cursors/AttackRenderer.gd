extends TileMap
class_name AttackRenderer

const GROUP_NAME := "combat_displays"

var attack : Attack
var map : ReferenceMap

var attack_center : Vector2

func _ready():
	add_to_group(GROUP_NAME)


func draw_display(to : Vector2, acceptable : bool):
	clear()
	
	if acceptable and attack:
		for cell in attack.attack(map.map, attack_center, get_closest_direction(to)):
			if Pathfinder.is_cell_in_range(map.center_cell,cell,map.tile_range):
				set_cellv(MapSpaceConverter.internal_map_to_map(cell,map),0)
		for display in get_tree().get_nodes_in_group(GROUP_NAME):
			display.attack = attack

func _on_map_change(new_map):
	map = new_map

static func get_closest_direction(to : Vector2) -> Vector2:
	to = to.normalized()
	var directions := [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]
	var lowest_distance := 10000
	var lowest_distance_index := 0
	
	for i in directions.size():
		var distance = to.distance_squared_to(directions[i])
		if distance < lowest_distance:
			lowest_distance = distance
			lowest_distance_index = i
	
	return directions[lowest_distance_index]
	
