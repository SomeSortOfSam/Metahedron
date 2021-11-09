extends Control
class_name WindowMover, "res://Assets/Editor Icons/WindowMover.png"

export var window_path : NodePath
export var tilemap_path : NodePath

onready var body : ColorRect = $Body

onready var window : Control = get_node(window_path)
onready var viewport_window : Control = window.get_parent()
onready var tilemap : TileMap = get_node(tilemap_path)
onready var tilemap_container : Control = tilemap.get_parent().get_parent()

signal accepted_window_movement(delta)

var is_dragging : bool = false setget set_is_dragging

func _ready():
	var _connection = get_tree().connect("screen_resized",self,"correct_window_pos",[],CONNECT_DEFERRED)

func correct_window_pos():
	emit_signal("accepted_window_movement",quatizize())

func _gui_input(event):
	if event is InputEventMouse:
		handle_mouse_event(event)

func handle_mouse_event(event : InputEventMouse):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		self.is_dragging = event.pressed
	if event is InputEventMouseMotion && is_dragging:
		var window_rect := window.get_rect()
		var viewport_rect := viewport_window.get_rect()
		viewport_rect.position = Vector2.ZERO
		
		emit_signal("accepted_window_movement",clamp_delta(event.get_relative(),window_rect,viewport_rect))

static func clamp_delta(delta : Vector2, window_rect : Rect2, viewport_rect : Rect2) -> Vector2:
	window_rect.position += delta
	if window_rect.position.x < viewport_rect.position.x:
		delta.x += viewport_rect.position.x - window_rect.position.x
	if window_rect.position.y < viewport_rect.position.y:
		delta.y += viewport_rect.position.y - window_rect.position.y
	if window_rect.position.x + window_rect.size.x > viewport_rect.position.x + viewport_rect.size.x:
		delta.x -= (window_rect.position.x + window_rect.size.x)-(viewport_rect.position.x + viewport_rect.size.x)
	if window_rect.position.y + window_rect.size.y > viewport_rect.position.y + viewport_rect.size.y:
		delta.y -= (window_rect.position.y + window_rect.size.y)-(viewport_rect.position.y + viewport_rect.size.y)
	return delta

func quatizize() -> Vector2:
	var window_rect := window.get_rect()
	var viewport_rect := viewport_window.get_rect()
	var cell_size = tilemap.cell_size * tilemap.global_scale
	var tilemap_container_rect := tilemap_container.get_rect()
	
	var center_cell_distance := get_center_cell_distance(tilemap_container_rect,cell_size)
	var center_cell_rect := Rect2(window_rect.position + center_cell_distance, cell_size)
	var quantiziation_rect = get_quantiziation_rect(viewport_rect,cell_size,center_cell_distance,\
	tilemap_container_rect)
	var delta := clamp_delta(Vector2.ZERO,center_cell_rect,quantiziation_rect)
	delta = round_to_nearest_cell(delta,center_cell_rect,quantiziation_rect)
	return delta

func round_to_nearest_cell(delta : Vector2, center_cell_rect : Rect2, quantiziation_rect : Rect2) -> Vector2:
	center_cell_rect.position += delta
	var pos := center_cell_rect.position - quantiziation_rect.position
	var cell_pos := pos
	cell_pos.x = stepify(cell_pos.x,center_cell_rect.size.x)
	cell_pos.y = stepify(cell_pos.y,center_cell_rect.size.y)
	return cell_pos - pos

func get_quantiziation_rect(viewport_rect : Rect2, cell_size : Vector2, \
center_cell_distance : Vector2, tilemap_container_rect : Rect2) -> Rect2:
	var rect := get_clamped_center_cell_rect(viewport_rect,center_cell_distance,\
	tilemap_container_rect,cell_size)
	return center_rect_by_partial_cells(rect,cell_size)

func get_clamped_center_cell_rect(rect : Rect2, center_cell_distance : Vector2,\
 tilemap_contaier_rect : Rect2, cell_size : Vector2) -> Rect2:
	rect.position += center_cell_distance
	rect.size -= center_cell_distance # equal and opisite
	
	rect.size -= tilemap_contaier_rect.position
	rect.size -= tilemap_contaier_rect.size/2
	rect.size += cell_size / 2
	
	return rect

func center_rect_by_partial_cells(rect : Rect2, cell_size : Vector2) -> Rect2:
	rect.position.x += fmod(rect.size.x,cell_size.x)/2
	rect.position.y += fmod(rect.size.y,cell_size.y)/2
	
	rect.size.x -= fmod(rect.size.x,cell_size.x)
	rect.size.y -= fmod(rect.size.y,cell_size.y)
	
	return rect

func get_center_cell_distance(tilemap_contaier_rect : Rect2, cell_size : Vector2) -> Vector2:
	var out := tilemap_contaier_rect.position
	out += tilemap_contaier_rect.size/2
	out.y += rect_size.y
	out -= cell_size / 2
	return out

func set_is_dragging(new_is_dragging):
	if is_dragging != new_is_dragging:
		is_dragging = new_is_dragging
		body.color.v += .1 if is_dragging else -.1
		if !is_dragging:
			emit_signal("accepted_window_movement",quatizize())

func _on_TopBar_mouse_entered():
	body.color.v += .1

func _on_TopBar_mouse_exited():
	body.color.v -= .1
