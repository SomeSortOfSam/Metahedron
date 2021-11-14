tool
extends TextureRect
class_name ScrollingBackround, "res://Assets/Editor Icons/ScrollingBackround.svg"

export var scroll_vector : Vector2

func _init():
	set_anchors_preset(Control.PRESET_WIDE)
	expand = true
	stretch_mode = TextureRect.STRETCH_TILE
	mouse_filter = MOUSE_FILTER_IGNORE

func _process(delta):
	scroll_negitive()
	scroll_x()
	scroll_y()

func scroll_negitive():
	if scroll_vector.x < 0 :
		if -margin_left < texture.get_size().x:
			margin_left += scroll_vector.x
		else: 
			margin_left = 0
		margin_right = 10
	if scroll_vector.y < 0:
		if -margin_top < texture.get_size().y:
			margin_top += scroll_vector.y
		else: 
			margin_top = 0
		margin_bottom = 10

func scroll_x():
	if scroll_vector.x > 0:
		if margin_left < 0 :
			rect_position.x += scroll_vector.x
		else: 
			rect_position.x = -texture.get_size().x
		margin_right = 10

func scroll_y():
	if scroll_vector.y > 0:
		if margin_top < 0 :
			rect_position.y += scroll_vector.y
		else: 
			rect_position.y = -texture.get_size().y
		margin_bottom = 10
