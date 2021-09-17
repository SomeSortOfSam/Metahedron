extends TextureRect

func _ready():
	# Hide Gut Button in release
	if (!OS.is_debug_build()):
		$GutButton.hide()
		$GutButton.disabled = true

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_ESCAPE):
		if ($Gut.get_gut().is_visible()):
			$Gut.get_gut().set_visible(false)
		
	
func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Map/Levels/LevelHandler.tscn")

func _on_LoadGameButton_pressed():
	pass # Replace with function body.

func _on_SettingsButton_pressed():
	pass # Replace with function body.

func _on_CreditsButton_pressed():
	pass # Replace with function body.

func _on_Gut_gut_ready():
	$Gut.get_gut().set_visible(false)
	
func _on_GutButton_pressed():
	if ($Gut.get_gut() != null):
		if (!$Gut.get_gut().is_visible()):
			$Gut.get_gut().maximize()
			$Gut.get_gut().set_visible(true)
			$Gut.get_gut().test_scripts()
