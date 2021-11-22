extends Control
class_name WindowMover, "res://Assets/Editor Icons/WindowMover.png"
## Moves the movement window without letting it go to far

export var window_path : NodePath

onready var body : ColorRect = $Body

onready var window : Control = get_node(window_path)
onready var viewport_window : Control = window.get_parent()

var is_dragging : bool = false setget set_is_dragging

signal accepted_window_movement(delta)

func _ready():
	var _connection = get_tree().connect("screen_resized",self,"correct_window_pos",[],CONNECT_DEFERRED)

func correct_window_pos():
	emit_signal("accepted_window_movement",clamp_delta(Vector2.ZERO,window.get_rect(),viewport_window.get_rect()))

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

func set_is_dragging(new_is_dragging):
	if is_dragging != new_is_dragging:
		is_dragging = new_is_dragging
		body.color.v += .1 if is_dragging else -.1

func _on_TopBar_mouse_entered():
	body.color.v += .1

func _on_TopBar_mouse_exited():
	body.color.v -= .1
