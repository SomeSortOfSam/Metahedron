extends Control

var is_dragging : bool = false

func _gui_input(event):
	if event is InputEventMouse:
		if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
			is_dragging = event.pressed
		if event is InputEventMouseMotion && is_dragging:
			var hypothetical = get_parent().get_rect()
			hypothetical.position += event.get_relative()
			if get_viewport_rect().encloses(hypothetical):
				get_parent().rect_position += event.get_relative()
