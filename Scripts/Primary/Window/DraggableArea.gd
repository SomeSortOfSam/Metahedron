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
	
	var window = get_parent().get_parent().get_rect()
	var viewportWindow = get_parent().get_parent().get_parent().get_rect()
	
	var hypothetical = window
	hypothetical.position += delta
	
	var currentDistance = window.position.distance_squared_to(viewportWindow.position + (viewportWindow.size / 2))
	var hypotheticalDistance = hypothetical.position.distance_squared_to(viewportWindow.position + (viewportWindow.size / 2))
	
	if viewportWindow.encloses(hypothetical) || hypotheticalDistance < currentDistance :
		emit_signal("accepted_window_movement",delta)
