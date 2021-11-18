class_name Pathfinder
## Utility class to help units get from point a to point b

static func is_occupied(map_point : Vector2, map) -> bool:
	return map.people.has(map_point)

static func is_walkable(map_point : Vector2, map) -> bool:
	if "map" in map:
		map_point = MapSpaceConverter.map_to_internal_map(map_point,map)
		map = map.map
	var tile_map_point := MapSpaceConverter.map_to_tilemap(map_point, map)
	var tile_type = map.tile_map.get_cellv(tile_map_point)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	var autotile_coords = map.tile_map.get_cell_autotile_coord(tile_map_point.x,tile_map_point.y)
	return tile_type != -1 && is_tile_type_walkable(tile_type, autotile_coords, map.tile_map)

static func is_path_walkable(to : Vector2, map) -> bool:
	var is_walkable := true
	var path = map.astar.get_point_path(MapSpaceConverter.map_to_index(Vector2.ZERO),MapSpaceConverter.map_to_index(to))
	if path.size() == 0:
		is_walkable = false
	for point in path:
		if !is_walkable(point,map):
			is_walkable = false
	return is_walkable

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

static func get_walkable_tiles(map) -> Array:
	var out := []
	for tile in map.tile_map.get_used_cells():
		if is_walkable(tile, map):
			out.append(tile)
	return out

static func get_walkable_tiles_in_range(map,walkable_tiles := []) -> Array:
	if walkable_tiles.size() < 1:
		walkable_tiles = get_walkable_tiles(map.map)
	var i := 0
	while i < walkable_tiles.size():
		var point = walkable_tiles[i]
		if !is_cell_in_range(map.center_cell, point, map.tile_range):
			walkable_tiles.remove(i)
			i -= 1
		i += 1
	return walkable_tiles

static func is_cell_in_range(center_point : Vector2, check_point : Vector2, tile_range : int) -> bool:
	var x = abs(center_point.x - check_point.x)
	var y = abs(center_point.y - check_point.y)
	var delta = x+y
	return delta <= tile_range

static func map_to_astar(map) -> AStar2D:
	var astar = AStar2D.new()
	var tiles = get_walkable_tiles(map)
	for tile in tiles:
		var cell = MapSpaceConverter.tilemap_to_map(tile,map)
		var index = MapSpaceConverter.map_to_index(cell)
		astar.add_point(index,cell)
		for neighbor in get_neighbors(cell, map):
			var neighbor_index = MapSpaceConverter.map_to_index(neighbor)
			if astar.has_point(neighbor_index):
				astar.connect_points(index,neighbor_index)
	return astar

static func get_neighbors(cell : Vector2, map) -> Array:
	var out := []
	for x in range(-1,2):
		for y in range(-1,2):
			var is_cardinal := (x == 0 && y != 0 || x != 0 && y == 0)
			var direction := Vector2(x,y)
			var neighbor := cell + direction
			var is_walkable := is_walkable(neighbor, map)
			if is_cardinal && is_walkable :
				out.append(neighbor)
	return out
