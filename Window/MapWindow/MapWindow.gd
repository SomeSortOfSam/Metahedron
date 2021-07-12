extends WindowDialog
class_name MapWindow

var map : Map setget set_map

onready var cursor : Cursor
onready var tilemap_container : Node2D = $TilemapContainer

func set_map(new_map : Map):
	map = new_map
	reinitalize_cursor()

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	add_child(cursor)

func center_tilemap():
	tilemap_container.position = get_centered_position()

func get_centered_position() -> Vector2:
	if map:
		var used_rect := map.get_used_rect()
		var cell_size := map.tile_map.cell_size
		return rect_size/2 - (used_rect.size *  cell_size/ 2) - used_rect.position * cell_size
	return rect_size/2
