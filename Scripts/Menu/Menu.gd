extends Control

onready var gut_button = $GutButton

var gut

func _ready():
	# Hide Gut Button in release
	if (!OS.is_debug_build()):
		gut_button.hide()
		gut_button.disabled = true

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_ESCAPE):
		if (gut.is_visible()):
			gut.set_visible(false)
		
	
func _on_NewGameButton_pressed():
	var _scene = get_tree().change_scene("res://Scripts/Primary/Map/LevelHandler.tscn")

func _on_LoadGameButton_pressed():
	pass # Replace with function body.

func _on_SettingsButton_pressed():
	pass # Replace with function body.

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
