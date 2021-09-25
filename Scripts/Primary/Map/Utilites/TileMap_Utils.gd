class_name TileMapUtilites

const NUM_BORDER_TILES := 3
const DEFUALT_CELL_SIZE := 16

static func get_centered_position(tile_map : TileMap ,rect_size : Vector2):
	if tile_map:
		var used_rect := tile_map.get_used_rect()
		var cell_size := tile_map.cell_size * tile_map.global_scale
		var tilemap_size := used_rect.size * cell_size
		var tilemap_position := used_rect.position * cell_size
		var top_left_position := tilemap_position + tilemap_size/2
		return rect_size/2 - top_left_position
	return rect_size/2

static func scale_around_tile(tile_map : TileMap, new_scale : Vector2, cell : Vector2):
	var old_cell_pos = tile_map.global_position + ((tile_map.map_to_world(cell) + (tile_map.cell_size * .5)) * tile_map.global_scale)
	tile_map.scale = new_scale
	var new_cell_pos = tile_map.global_position + ((tile_map.map_to_world(cell) + (tile_map.cell_size * .5)) * tile_map.global_scale)
	var delta = new_cell_pos - old_cell_pos
	tile_map.position -= delta

static func get_border_amount(tile_map : TileMap):
	return NUM_BORDER_TILES * tile_map.scale.x * tile_map.cell_size.x

static func get_used_map_rect(tile_map : TileMap) -> Rect2:
	return tile_map.get_used_rect()

static func get_used_local_rect(tile_map : TileMap) -> Rect2:
	var rect := get_used_local_rect_without_margin(tile_map)
	rect = rect.grow(get_border_amount(tile_map))
	return rect

static func get_used_global_rect(tile_map : TileMap) -> Rect2:
	return get_used_local_rect(tile_map) 

static func get_used_local_rect_without_margin(tile_map : TileMap) -> Rect2:
	var rect := get_used_map_rect(tile_map)
	rect.size *= tile_map.scale * tile_map.cell_size
	rect.position = tile_map.position 
	return rect
