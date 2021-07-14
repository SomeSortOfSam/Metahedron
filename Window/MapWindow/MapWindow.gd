extends WindowDialog
class_name MapWindow

var map : Map setget set_map

onready var cursor : Cursor
onready var tilemap_container : YSort = $TilemapContainer

func set_map(new_map : Map):
	map = new_map
	reinitalize_cursor()

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	if tilemap_container == null:
		tilemap_container = $TilemapContainer
	tilemap_container.add_child(cursor)

func center_tilemap():
	tilemap_container.position = get_centered_position()

func get_centered_position() -> Vector2:
	if map:
		var used_rect := map.get_used_rect()
		var cell_size := map.tile_map.cell_size * map.tile_map.global_scale
		var tilemap_size := used_rect.size * cell_size
		var tilemap_position := used_rect.position * cell_size
		var top_left_position := tilemap_position + tilemap_size/2
		return rect_size/2 - top_left_position
	return rect_size/2
