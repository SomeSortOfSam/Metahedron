class_name Pathfinder

static func is_occupied(map_point : Vector2, map : Map) -> bool:
	return map.people.has(map_point)

static func is_walkable(map_point : Vector2, map : Map) -> bool:
	var tile_map_point := MapSpaceConverter.map_to_tilemap(map_point, map)
	var tile_type = map.tile_map.get_cellv(tile_map_point)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	var autotile_coords = map.tile_map.get_cell_autotile_coord(tile_map_point.x,tile_map_point.y)
	return tile_type != -1 && is_tile_type_walkable(tile_type, autotile_coords, map.tile_map)

static func is_tile_type_walkable(tile_type : int, autotile_coords : Vector2, tile_map : TileMap) -> bool:
	if tile_map.tile_set && tile_map.tile_set.get_tiles_ids().find(tile_type) != -1:
		if tile_map.tile_set.tile_get_tile_mode(tile_type) == TileSet.SINGLE_TILE:
			return is_single_tile_type_walkable(tile_type, tile_map)
		else:
			return is_autotile_type_walkable(tile_type,autotile_coords, tile_map)
	return true

static func is_single_tile_type_walkable(tile_type : int, tile_map : TileMap) -> bool:
	if tile_map.tile_set:
		return tile_map.tile_set.tile_get_shape_count(tile_type) <= 0
	return true

static func is_autotile_type_walkable(tile_type : int, autotile_coords : Vector2, tile_map : TileMap) -> bool:
	if tile_map.tile_set:
		for dic in tile_map.tile_set.tile_get_shapes(tile_type):
			if dic["autotile_coord"] == autotile_coords:
				return false
		return true
	return true

static func get_walkable_tiles(map : Map) -> Array:
	var out := []
	var used_rect = map.tile_map.get_used_rect()
	for x in used_rect.size.x:
		for y in used_rect.size.y:
			var tile := Vector2(x,y)
			if is_walkable(tile, map):
				out.append(tile)
	return out

static func get_walkable_tiles_in_range(map_point : Vector2, tile_range : int, map : Map) -> Array:
	var out := get_walkable_tiles(map)
	var i := 0
	while i < out.size():
		var point = out[i]
		if !is_cell_in_range(map_point, point, tile_range):
			out.remove(i)
			i -= 1
		i += 1
	return out

static func is_cell_in_range(center_point : Vector2, check_point : Vector2, tile_range : int) -> bool:
	return abs(center_point.x - check_point.x) + abs(center_point.y - check_point.y) < tile_range
