extends WindowDialog
class_name MapWindow

var map : Map setget set_map

onready var cursor : Cursor
onready var tilemap_container : YSort = $TilemapContainer

func set_map(new_map : Map):
	map = new_map
	if map.tile_map.get_parent():
		map.tile_map.get_parent().remove_child(map.tile_map)
	if !tilemap_container:
		tilemap_container = $TilemapContainer
	tilemap_container.add_child(map.tile_map)
	reinitalize_cursor()

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)

func center_tilemap():
	tilemap_container.position = get_centered_position()

func get_centered_position() -> Vector2:
	if map:
		var used_rect := map.get_used_rect()
		var cell_size := map.tile_map.cell_size * map.tile_map.global_scale
		var tilemap_size := used_rect.size * cell_size
		var tilemap_position := used_rect.position * cell_size
		var top_left_position := map.tile_map.position + tilemap_position + tilemap_size/2
		return rect_size/2 - top_left_position
	return rect_size/2

