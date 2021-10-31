tool
extends Sprite
class_name Placeholder,"res://Assets/Editor Icons/Placeholder.png"

const TOOL_ALPHA := .2
const RECT_WIDTH := 2

export var definition : Resource setget set_definition
export var cell_offset : Vector2 setget set_offset

func set_definition(new_definition):
	if "level_texture" in new_definition && "level_offset" in new_definition && "level_scale" in new_definition:
		definition = new_definition
		texture = definition.level_texture
		offset = definition.level_offset
		scale = definition.level_scale
	elif !new_definition:
		definition = null
		texture = null
		offset = Vector2.ZERO
		scale = Vector2.ONE
	else:
		assert(false, "Definition is not a valid resource type")

func set_offset(new_offset):
	cell_offset = new_offset
	var tilemap := get_parent() as TileMap
	if tilemap:
		position = align_to_tilemap(position,tilemap)
		update()

#align to grid
func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		var tilemap := get_parent() as TileMap
		if Engine.editor_hint && tilemap:
			set_notify_transform(false)
			position = align_to_tilemap(position,tilemap)
			set_notify_transform(true)

func align_to_tilemap(position : Vector2, tilemap : TileMap) -> Vector2:
	var aligned_pos := tilemap.map_to_world(tilemap.world_to_map(position))
	return aligned_pos + tilemap.cell_size/2 + cell_offset

func get_tool_color() -> Color:
	return Color(1,1,1,TOOL_ALPHA)

func _draw():
	if definition:
		draw_index_rect()

func draw_index_rect():
	var tilemap := get_parent() as TileMap
	if Engine.editor_hint && tilemap:
		var rect = get_cell_rect(tilemap)
		draw_rect(rect,get_tool_color(),false,RECT_WIDTH)

func get_cell_rect(tilemap):
	var cell = tilemap.world_to_map(position)
	var cell_position = tilemap.map_to_world(cell) - position + Vector2.ONE * RECT_WIDTH *.5
	return Rect2(cell_position,tilemap.cell_size - Vector2.ONE * RECT_WIDTH)
