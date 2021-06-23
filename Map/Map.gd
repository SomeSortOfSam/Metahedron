extends Reference
class_name Map

var rect : Rect2
var tile_map : TileMap
var units := {}

func _init(tile_map : TileMap = TileMap.new()):
	self.tile_map = tile_map
	rect = tile_map.get_used_rect()

func world_to_map(world_point : Vector2) -> Vector2:
	return (((world_point - tile_map.position)/(tile_map.cell_size * tile_map.scale)) - rect.position).floor()

func map_to_world(map_point : Vector2) -> Vector2:
	return ((map_point + rect.position)*(tile_map.cell_size * tile_map.scale)) + tile_map.position + tile_map.cell_size/2

func is_occupied(map_point : Vector2) -> bool:
	return units.has(map_point)

func is_walkable(map_point : Vector2) -> bool:
	var tile_type = tile_map.get_cellv(map_point + rect.position)
	return tile_type != -1 && is_tile_type_walkable(tile_type)

func is_tile_type_walkable(tile_type : int) -> bool:
	if tile_map.tile_set != null && tile_map.tile_set.get_tiles_ids().find(tile_type) != -1:
		return tile_map.tile_set.tile_get_shape_count(tile_type) <= 0
	return true

func clamp(map_point : Vector2) -> Vector2:
	map_point.x = clamp(map_point.x, 0, rect.size.x - 1 )
	map_point.y = clamp(map_point.y, 0, rect.size.y - 1)
	return map_point
