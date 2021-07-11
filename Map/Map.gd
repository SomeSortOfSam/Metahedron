extends Reference
class_name Map

var tile_map : TileMap
var units := {}

func _init(new_tilemap : TileMap):
	tile_map = new_tilemap

func get_used_rect() -> Rect2:
	return tile_map.get_used_rect()

func world_to_map(world_point : Vector2) -> Vector2:
	var tile_world_point = (world_point - tile_map.global_position) / tile_map.scale
	var tile_map_point = tile_world_point / tile_map.cell_size
	var map_point = tile_map_point - get_used_rect().position
	return map_point.floor()

func map_to_world(map_point : Vector2) -> Vector2:
	var tile_map_point = map_point + get_used_rect().position
	var tile_world_point = tile_map.map_to_world(tile_map_point)
	var world_point = (tile_world_point * tile_map.scale) + tile_map.position
	var half_offset = tile_map.cell_size * tile_map.scale / 2
	return world_point + half_offset

func is_occupied(map_point : Vector2) -> bool:
	return units.has(map_point)

func is_walkable(map_point : Vector2) -> bool:
	var tile_map_point := map_point + get_used_rect().position
	var tile_type = tile_map.get_cellv(tile_map_point)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	return tile_type != -1 && is_tile_type_walkable(tile_type, tile_map.get_cell_autotile_coord(tile_map_point.x,tile_map_point.y))


func is_tile_type_walkable(tile_type : int, autotile_coords : Vector2 = Vector2.ZERO) -> bool:
	if tile_map.tile_set != null && tile_map.tile_set.get_tiles_ids().find(tile_type) != -1:
		var tile_set := tile_map.tile_set
		var tile_mode := tile_set.tile_get_tile_mode(tile_type)
		if tile_mode == TileSet.SINGLE_TILE:
			return tile_set.tile_get_shape_count(tile_type) <= 0
		else:
			var shapes := tile_set.tile_get_shapes(tile_type)
			for dic in shapes:
				if dic["autotile_coord"] == autotile_coords:
					return false
			return true
	return true

func clamp(map_point : Vector2) -> Vector2:
	var used_rect := get_used_rect()
	map_point.x = clamp(map_point.x, 0, used_rect.size.x - 1 )
	map_point.y = clamp(map_point.y, 0, used_rect.size.y - 1)
	return map_point
