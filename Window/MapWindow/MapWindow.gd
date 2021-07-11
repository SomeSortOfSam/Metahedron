extends WindowDialog
class_name MapWindow

var map : Map setget set_map

onready var cursor : Cursor
onready var path : Path2D = $Path2D
onready var follower : PathFollow2D = $Path2D/PathFollow2D
onready var tilemap_container : Node2D = $Path2D/PathFollow2D/TilemapContainer

func set_map(new_map : Map):
	map = new_map
	reinitalize_cursor()

func reinitalize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	add_child(cursor)

func center_tilemap():
	assert(false, "center_tilemap not implemented")

func center_tilemap_immedite():
	assert(false, "center_tilemap_immedite not implemented")
