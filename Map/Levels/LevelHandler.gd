extends Node2D
class_name LevelHandler

export var packed_level_data : PackedScene
export var debug : bool

var map : Map
var cursor : Cursor
var is_dragging : bool = false

func _ready():
	initialize_level(validate_level_data(packed_level_data))
	recenter_map()
	get_tree().connect("screen_resized",self,"call_deferred",["recenter_map"])

func recenter_map():
	move_tilemap(map.tile_map.position - TileMapUtilites.get_centered_position(map,get_viewport_rect().size))

func initialize_level(level_data : LevelData):
	add_child(level_data)
	map = level_data.to_map()
	intialize_cursor()

func intialize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)
	cursor.connect("accept_pressed",map,"get_window",[self, true])
	cursor.connect("confirmed_movement",self,"cell_delta_to_transform")

# warning-ignore:shadowed_variable
func validate_level_data(packed_level_data : PackedScene) -> LevelData:
	var unpacked_level_data := packed_level_data.instance() as LevelData
	assert(unpacked_level_data != null, "Level data for " + name + " was not of type level data")
	if unpacked_level_data:
		return unpacked_level_data
	else:
		return LevelData.new()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			is_dragging = event.is_pressed()
		if event.button_index == 4:
			TileMapUtilites.scale_around_tile(map,map.tile_map.scale * 1.1, cursor.cell)
		if event.button_index == 5:
			TileMapUtilites.scale_around_tile(map,map.tile_map.scale * .9, cursor.cell)
	elif event is InputEventMouseMotion && is_dragging:
		move_tilemap(-event.get_relative())

func cell_delta_to_transform(delta):
	move_tilemap(delta * map.tile_map.cell_size * map.tile_map.scale * .5)

func move_tilemap(delta : Vector2):
	map.tile_map.position -= delta 
	constrain_tilemap()
	if debug:
		update()

func constrain_tilemap():
	var edge_rect := map.get_used_local_rect()
	var window_rect := get_viewport_rect()
	map.tile_map.position.x = constrain_tilemap_horizontal(edge_rect, window_rect)
	map.tile_map.position.y = constrain_tilemap_vertical(edge_rect, window_rect)

func constrain_tilemap_horizontal(edge_rect : Rect2, window_rect : Rect2) -> float:
	if edge_rect.end.x < window_rect.position.x:
		return window_rect.end.x + map.get_border_amount()
	if edge_rect.position.x > window_rect.end.x:
		return window_rect.position.x - edge_rect.size.x + map.get_border_amount()
	return edge_rect.position.x + map.get_border_amount()

func constrain_tilemap_vertical(edge_rect : Rect2, window_rect : Rect2) -> float:
	if edge_rect.end.y < window_rect.position.y:
		return window_rect.end.y + map.get_border_amount()
	if edge_rect.position.y > window_rect.end.y:
		return window_rect.position.y - edge_rect.size.y + map.get_border_amount()
	return edge_rect.position.y + map.get_border_amount()

func _draw():
	if debug:
		draw_rect(map.get_used_local_rect(),Color.green,false)
		draw_rect(get_viewport_rect(),Color.red,false)
