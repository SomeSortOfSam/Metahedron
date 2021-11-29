extends TileMap
class_name AttackRenderer

const GROUP_NAME := "combat_displays"
const DIRECTIONS := [Vector2.UP,Vector2.DOWN,Vector2.LEFT,Vector2.RIGHT]

var attack : Attack
var map : ReferenceMap

var attack_center : Vector2

func _ready():
	add_to_group(GROUP_NAME)

func draw_display(to : Vector2, acceptable : bool):
	clear()
	
	var chosen_direction := Vector2.ZERO
	if acceptable: 
		 chosen_direction = get_closest_direction(to)
	
	if acceptable && attack:
		for direction in DIRECTIONS:
			for cell in attack.attack(map.map, attack_center, direction):
				if Pathfinder.is_cell_in_range(map.center_cell,cell,map.tile_range):
					cell = MapSpaceConverter.internal_map_to_map(cell,map)
					var tile := get_cellv(cell)
					set_cellv(cell,0 if chosen_direction == direction || tile == 0 else 1)
		for display in get_tree().get_nodes_in_group(GROUP_NAME):
			display.attack = attack

func _on_map_change(new_map):
	map = new_map

static func get_closest_direction(to : Vector2) -> Vector2:
	to = to.normalized()
	
	var lowest_distance := 10000
	var lowest_distance_index := 0
	
	for i in DIRECTIONS.size():
		var distance = to.distance_squared_to(DIRECTIONS[i])
		if distance < lowest_distance:
			lowest_distance = distance
			lowest_distance_index = i
	
	return DIRECTIONS[lowest_distance_index]
	
