extends Control

onready var gut_button = $VBoxContainer/VBoxContainer/GutButton
onready var main_menu = $VBoxContainer

var gut
var desiered_pos : Vector2

func _ready():
	# Hide Gut Button in release
	if (!OS.is_debug_build()):
		gut_button.hide()
		gut_button.disabled = true

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_ESCAPE):
		if (gut.is_visible()):
			gut.set_visible(false)
		desiered_pos = Vector2.ZERO

func _process(delta):
	if main_menu.rect_position != desiered_pos:
		main_menu.rect_position = lerp(main_menu.rect_position,desiered_pos,.1 * delta)

func _on_PlayButton_pressed():
	var _scene = get_tree().change_scene("res://Scripts/Primary/Map/LevelHandler.tscn")

func _on_OptionsButton_pressed():
	desiered_pos.x = rect_size.x

func _on_LoreButton_pressed():
	desiered_pos.x = -rect_size.x

func _on_CreditsButton_pressed():
	pass # Replace with function body.

func _on_Gut_gut_ready():
	gut = $Gut.get_gut()
	gut.set_visible(false)
	
func _on_GutButton_pressed():
	if (gut != null):
		if (!gut.is_visible()):
			gut.maximize()
			gut.set_visible(true)
			gut.test_scripts()
