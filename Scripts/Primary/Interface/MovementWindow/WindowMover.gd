extends Control
class_name WindowMover, "res://Assets/Editor Icons/WindowMover.png"
## Moves the movement window without letting it go to far

export var window_path : NodePath

onready var body : ColorRect = $Body

onready var window : Control = get_node(window_path)
onready var viewport_window : Control = window.get_parent()

var is_dragging : bool = false setget set_is_dragging
var locked := false

signal accepted_window_movement(delta)

func set_is_dragging(new_is_dragging):
	if is_dragging != new_is_dragging:
		is_dragging = new_is_dragging
		body.color.v += .1 if is_dragging else -.1

func _ready():
	var _connection = get_tree().connect("screen_resized",self,"correct_window_pos",[],CONNECT_DEFERRED)

func _gui_input(event):
	if event is InputEventMouse && !locked:
		handle_mouse_event(event)

func correct_window_pos():
	emit_signal("accepted_window_movement",correct_delta(Vector2.ZERO))

func handle_mouse_event(event : InputEventMouse):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		self.is_dragging = event.pressed
	if event is InputEventMouseMotion && is_dragging:
		emit_signal("accepted_window_movement",correct_delta(event.get_relative()))

func correct_delta(delta) -> Vector2:
	var window_rect := window.get_rect()
	var viewport_rect := viewport_window.get_rect()
	viewport_rect.position = Vector2.ZERO
	for other_window in window.get_parent().get_children():
		if other_window is MovementWindow && other_window != window && other_window.visible:
			delta = disinclude_delta(delta,window_rect,other_window.get_rect())
	delta = clamp_delta(delta,window_rect,viewport_rect)
	return delta

func lock():
	locked = true
	mouse_default_cursor_shape = Control.CURSOR_ARROW

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

static func disinclude_delta(delta : Vector2, window_rect : Rect2, other_window_rect : Rect2) -> Vector2:
	window_rect.position += delta
	window_rect.position -= other_window_rect.position
	other_window_rect.position = Vector2.ZERO

	var clip_rect = window_rect.clip(other_window_rect)

	if clip_rect.size.x > 0 && clip_rect.size.y > 0:
		if clip_rect.size.x < clip_rect.size.y:
			if clip_rect.position.x > 0:
				delta.x += clip_rect.size.x
			else:
				delta.x -= clip_rect.size.x
		else:
			if clip_rect.position.y > 0:
				delta.y += clip_rect.size.y
			else:
				delta.y -= clip_rect.size.y
		
	return delta

func _on_TopBar_mouse_entered():
	if !locked:
		body.color.v += .1

func _on_TopBar_mouse_exited():
	if !locked:
		body.color.v -= .1
