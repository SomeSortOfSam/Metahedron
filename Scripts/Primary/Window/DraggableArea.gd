extends Control

onready var body : ColorRect = $Body

signal accepted_window_movement(delta)

var is_dragging : bool = false setget set_is_dragging

func _gui_input(event):
	if event is InputEventMouse:
		handle_mouse_event(event)

func handle_mouse_event(event : InputEventMouse):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		self.is_dragging = event.pressed
	if event is InputEventMouseMotion && is_dragging:
		check_delta(event.get_relative())

func check_delta(delta : Vector2):
	
	var window = get_parent().get_parent().get_rect()
	var viewportWindow = get_parent().get_parent().get_parent().get_rect()
	
	var hypothetical = window
	hypothetical.position += delta
	
	var currentDistance = window.position.distance_squared_to(viewportWindow.position + (viewportWindow.size / 2))
	var hypotheticalDistance = hypothetical.position.distance_squared_to(viewportWindow.position + (viewportWindow.size / 2))
	
	if viewportWindow.encloses(hypothetical) || hypotheticalDistance < currentDistance :
		emit_signal("accepted_window_movement",delta)

func set_is_dragging(new_is_dragging):
	if is_dragging != new_is_dragging:
		is_dragging = new_is_dragging
		body.color.v += .1 if is_dragging else -.1

func _on_TopBar_mouse_entered():
	body.color.v += .1

func _on_TopBar_mouse_exited():
	body.color.v -= .1
