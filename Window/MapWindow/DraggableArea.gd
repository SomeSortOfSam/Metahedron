extends Control

signal accepted_window_movement(delta)

var is_dragging : bool = false

func _gui_input(event):
	if event is InputEventMouse:
		handle_mouse_event(event)

func handle_mouse_event(event : InputEventMouse):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		is_dragging = event.pressed
	if event is InputEventMouseMotion && is_dragging:
		check_delta(event.get_relative())


func check_delta(delta : Vector2):
	var hypothetical = get_parent().get_rect()
	hypothetical.position += delta
	if get_viewport_rect().encloses(hypothetical):
		emit_signal("accepted_window_movement",delta)
