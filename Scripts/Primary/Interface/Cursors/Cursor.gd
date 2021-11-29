extends Sprite
class_name Cursor, "res://Assets/Editor Icons/Cursor.png"
## A cursor for WindowCursor that draws a texture on a tile

var map : Map

func setup_scale():
	scale = map.tile_map.scale
	scale *= map.tile_map.cell_size / map.tile_map.scale / texture.get_size()

func draw_display(cell : Vector2, acceptable : bool):
	if acceptable:
		position = MapSpaceConverter.map_to_local(cell,map)
	modulate.a = 1 if acceptable else 0

func _on_map_change(new_map):
	map = new_map
	setup_scale()
