extends Attack
class_name HitscanAttack

export var piercing : bool
export var wrap_around : bool

var has_hit_character := false
var has_hit_end := false

func attack(map : Map, center_cell : Vector2, direction : Vector2) -> PoolVector2Array:
	has_hit_character = false
	has_hit_end = false
	return .attack(map,center_cell,direction)

func add_windows_cells(out : PoolVector2Array, window, source_window, bitmask_deltas : PoolVector2Array, direction : Vector2, tile_size : Vector2) -> PoolVector2Array:
	var relative_center = get_realative_center(window,source_window)
	while (!has_hit_character || piercing):
		for delta in bitmask_deltas:
			var cell = delta + relative_center
			out.append(cell)
			has_hit_character = has_hit_character && Pathfinder.is_occupied(cell,window.map.map)
		relative_center += tile_size * direction
		if !window.get_parent().get_global_rect().has_point(MapSpaceConverter.map_to_global(relative_center,window.map)):
			if !wrap_around || has_hit_end:
				break
			has_hit_end = true
			relative_center.y = relative_center.y if direction.y == 0 else -relative_center.y
			relative_center.x = relative_center.x if direction.x == 0 else -relative_center.x
	return out
