class_name Pathfinder

static func get_walkable_tiles(map : Map) -> Array:
	var out := []
	for x in map.rect.size.x:
		for y in map.rect.size.y:
			var tile := Vector2(x,y)
			if map.is_walkable(tile):
				out.append(tile)
	return out

static func get_walkable_tiles_in_range(map : Map , map_point : Vector2, tile_range : int) -> Array:
	var out := get_walkable_tiles(map)
	for i in out.size():
		var point = out[i]
		if abs(map_point.x - point.x) > tile_range or abs(map_point.y - point.y) > tile_range :
			out.remove(i)
			i -= 1
	return out

static func map_to_index(map : Map, map_point : Vector2) -> int:
	return int(map_point.y * map.rect.size.x + map_point.x)
