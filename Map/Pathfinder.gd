class_name Pathfinder

static func get_walkable_tiles(map) -> Array:
	var out := []
	var used_rect = map.get_used_rect()
	for x in used_rect.size.x:
		for y in used_rect.size.y:
			var tile := Vector2(x,y)
			if map.is_walkable(tile):
				out.append(tile)
	return out

static func get_walkable_tiles_in_range(map , map_point : Vector2, tile_range : int) -> Array:
	var out := get_walkable_tiles(map)
	for i in out.size():
		var point = out[i]
		if abs(map_point.x - point.x) > tile_range or abs(map_point.y - point.y) > tile_range :
			out.remove(i)
			i -= 1
	return out

static func map_to_index(map, map_point : Vector2) -> int:
	return int(map_point.y * map.get_used_rect().size.x + map_point.x)

static func world_to_map(map, world_point : Vector2) -> Vector2:
	var tile_world_point = (world_point - map.tile_map.global_position) /  map.tile_map.scale
	var tile_map_point = tile_world_point /  map.tile_map.cell_size
	var map_point = tile_map_point -  map.get_used_rect().position
	return map_point.floor()

static func map_to_world(map, map_point : Vector2) -> Vector2:
	var tile_map_point = map_point + map.get_used_rect().position
	var tile_world_point = map.tile_map.map_to_world(tile_map_point)
	var world_point = (tile_world_point * map.tile_map.scale) + map.tile_map.global_position
	var half_offset = map.tile_map.cell_size * map.tile_map.scale / 2
	return world_point + half_offset
