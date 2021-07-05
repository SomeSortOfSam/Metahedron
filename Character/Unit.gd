tool
extends Path2D
class_name Unit

const TOOL_ALPHA := .2

export var friendly := false
export var character : Resource

var map

func _draw(is_editor := Engine.editor_hint):
	var tilemap := get_parent() as TileMap
	if is_editor && tilemap:
		var color := Color.green if friendly else Color.red
		color.a = TOOL_ALPHA
		position = tilemap.map_to_world(tilemap.world_to_map(position)) + tilemap.cell_size/2
		draw_rect(Rect2(-tilemap.cell_size/2,tilemap.cell_size),color)
