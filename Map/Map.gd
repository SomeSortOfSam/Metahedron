extends Reference
class_name Map

var rect : Rect2
var tile_map : TileMap

func _init(tile_map : TileMap = TileMap.new()):
	self.tile_map = tile_map
	rect = tile_map.get_used_rect()

func world_to_map(world_point : Vector2) -> Vector2:
	return (((world_point - tile_map.position)/(tile_map.cell_size * tile_map.scale)) - rect.position).floor()

func map_to_world(map_point : Vector2) -> Vector2:
	return ((map_point + rect.position)*(tile_map.cell_size * tile_map.scale)) + tile_map.position + tile_map.cell_size/2

func map_to_index(map_point : Vector2) -> int:
	return int(map_point.y * rect.size.x + map_point.x)
