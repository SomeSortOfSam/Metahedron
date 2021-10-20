extends Node2D
class_name MapScaler

onready var tile_map : TileMap = $TileMap

func _ready():
	var _connection = get_parent().connect("resized",self,"correct_transform")

func correct_transform():
	scale()
	center()

func center():
	position = TileMapUtilites.get_centered_position(tile_map,get_parent().rect_size)

func scale():
	var tile_rect = add_border(tile_map.get_used_rect())
	var max_cell_size = get_parent().rect_size/tile_rect.size
	var square_cell_size = Vector2(min(max_cell_size.x,max_cell_size.y),min(max_cell_size.x,max_cell_size.y))
	scale = square_cell_size / tile_map.cell_size

func add_border(tile_rect : Rect2) -> Rect2:
	tile_rect.size.y += TileMapUtilites.NUM_BORDER_TILES
	return tile_rect

func tile_to_local(tile_rect : Rect2) -> Rect2:
	tile_rect.size *= tile_map.cell_size
	tile_rect.position *= tile_map.cell_size
	return tile_rect

func get_local_used_rect() -> Rect2:
	var tile_rect = tile_map.get_used_rect()
	tile_rect = add_border(tile_rect)
	tile_rect = tile_to_local(tile_rect)
	return tile_rect
