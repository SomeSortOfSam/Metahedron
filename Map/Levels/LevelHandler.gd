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
	move_tilemap(map.tile_map.position - TileMapUtilites.get_centered_position(map.tile_map,get_viewport_rect().size))

func initialize_level(level_data : LevelData):
	add_child(level_data)
	map = level_data.to_map()
	map.connect("repopulated",self,"intialize_cursor")
	map.repopulate_displays()

func intialize_cursor():
	if cursor:
		cursor.free()
	cursor = Cursor.new(map)
	map.tile_map.add_child(cursor)
	map.tile_map.move_child(cursor,0)
	cursor.connect("accept_pressed",self,"get_window",[true])
	cursor.connect("confirmed_movement",self,"cell_delta_to_transform")

func get_window(cell, popup):
	if Pathfinder.is_occupied(cell,map):
		var person : Person = map.people[cell]
		var movement_window = person.window
		if movement_window == null:
			person.initialize_window(map, popup)
			movement_window = person.window
			get_parent().add_child(movement_window)
		if popup:
			movement_window.popup_around_tile()
		return movement_window
	return null

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
			TileMapUtilites.scale_around_tile(map.tile_map,map.tile_map.scale * 1.1, MapSpaceConverter.map_to_tilemap(cursor.cell,map))
		if event.button_index == 5:
			TileMapUtilites.scale_around_tile(map.tile_map,map.tile_map.scale * .9, MapSpaceConverter.map_to_tilemap(cursor.cell,map))
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
	var edge_rect := TileMapUtilites.get_used_local_rect(map.tile_map)
	var window_rect := get_viewport_rect()
	map.tile_map.position.x = constrain_tilemap_horizontal(edge_rect, window_rect)
	map.tile_map.position.y = constrain_tilemap_vertical(edge_rect, window_rect)

func constrain_tilemap_horizontal(edge_rect : Rect2, window_rect : Rect2) -> float:
	if edge_rect.end.x < window_rect.position.x:
		return window_rect.end.x + TileMapUtilites.get_border_amount(map.tile_map)
	if edge_rect.position.x > window_rect.end.x:
		return window_rect.position.x - edge_rect.size.x +TileMapUtilites.get_border_amount(map.tile_map)
	return edge_rect.position.x + TileMapUtilites.get_border_amount(map.tile_map)

func constrain_tilemap_vertical(edge_rect : Rect2, window_rect : Rect2) -> float:
	if edge_rect.end.y < window_rect.position.y:
		return window_rect.end.y + TileMapUtilites.get_border_amount(map.tile_map)
	if edge_rect.position.y > window_rect.end.y:
		return window_rect.position.y - edge_rect.size.y + TileMapUtilites.get_border_amount(map.tile_map)
	return edge_rect.position.y + TileMapUtilites.get_border_amount(map.tile_map)

func _draw():
	if debug:
		draw_rect(map.get_used_local_rect(),Color.green,false)
		draw_rect(get_viewport_rect(),Color.red,false)
