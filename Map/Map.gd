extends Reference
class_name Map

var rect : Rect2
var tile_map : TileMap

func _init(tile_map : TileMap = TileMap.new()):
	self.tile_map = tile_map
	rect = tile_map.get_used_rect()

func world_to_map(world_point : Vector2) -> Vector2:
	return world_point/tile_map.cell_size - rect.position

func map_to_world(map_point : Vector2) -> Vector2:
	return (map_point + rect.position) * tile_map.cell_size
