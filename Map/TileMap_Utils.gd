extends Object
class_name TileMapUtilites

static func get_centered_position(map : Map ,rect_size : Vector2):
	if map:
		var used_rect := map.get_used_map_rect()
		var cell_size := map.tile_map.cell_size * map.tile_map.global_scale
		var tilemap_size := used_rect.size * cell_size
		var tilemap_position := used_rect.position * cell_size
		var top_left_position := tilemap_position + tilemap_size/2
		return rect_size/2 - top_left_position
	return rect_size/2
