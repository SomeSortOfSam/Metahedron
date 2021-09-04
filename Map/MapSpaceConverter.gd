class_name MapSpaceConverter

static func map_to_index(map_point : Vector2, map : Map) -> int:
	return int(map_point.y * map.tile_map.get_used_rect().size.x + map_point.x)

static func map_to_tilemap(map_point : Vector2, map : Map) -> Vector2:
	return map_point + map.tile_map.get_used_rect().position

static func tilemap_to_map(tilemap_point : Vector2, map : Map) -> Vector2:
	return tilemap_point - map.tile_map.get_used_rect().position

static func map_to_local(map_point : Vector2, map : Map) -> Vector2:
	return map.tile_map.map_to_world(map_to_tilemap(map_point, map)) + map.tile_map.cell_size/2

static func local_to_map(local_point : Vector2, map : Map) -> Vector2:
	return tilemap_to_map(map.tile_map.world_to_map(local_point), map)

static func map_to_global(map_point : Vector2, map : Map) -> Vector2:
	return map_to_local(map_point, map) * map.tile_map.scale + map.tile_map.global_position

static func global_to_map(global_point : Vector2, map : Map) -> Vector2:
	return local_to_map((global_point - map.tile_map.global_position)/ map.tile_map.scale, map) 

static func internal_map_to_map(internal_map_point : Vector2, map) -> Vector2:
	return internal_map_point - map.get_refrence_rect().position

static func map_to_internal_map(map_point : Vector2, map) -> Vector2:
	return map_point + map.get_refrence_rect().position
