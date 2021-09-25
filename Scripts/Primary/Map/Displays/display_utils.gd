class_name DisplayUtilies

const TOOL_ALPHA := .2

static func draw_index_rect(item):
	var tilemap := item.get_parent() as TileMap
	if (Engine.editor_hint || item.override_in_editor) && tilemap:
		var rect = get_cell_rect(item,tilemap)
		rect = apply_index_transformation(item,tilemap,rect)
		item.draw_rect(rect,item.get_tool_color(),false,get_index_offset(tilemap).x)

static func get_cell_rect(item,tilemap):
	var cell = tilemap.world_to_map(item.position - item.get_offset())
	var cell_position = tilemap.map_to_world(cell) - item.position
	return Rect2(cell_position,tilemap.cell_size)

static func apply_index_transformation(item,tilemap,rect) -> Rect2:
	var index_offset = get_index_offset(tilemap)
	rect.position += index_offset * item.get_index()
	rect.size -= index_offset * item.get_index() * 2
	return rect

static func get_index_offset(tilemap):
	return tilemap.cell_size/2/tilemap.get_child_count()

