extends Control

onready var gut_button = $VBoxContainer/Buttons2/GutButton

signal request_options()
signal request_lore()
signal request_credits()
signal request_gut()
signal request_game()

func _ready():
	# Hide Gut Button in release
	if (!OS.is_debug_build()):
		gut_button.hide()
		gut_button.disabled = true

func _on_PlayButton_pressed():
	emit_signal("request_game")

func _on_OptionsButton_pressed():
	emit_signal("request_options")

func _on_LoreButton_pressed():
	emit_signal("request_lore")

func _on_CreditsButton_pressed():
	emit_signal("request_credits")

func _on_GutButton_pressed():
	emit_signal("request_gut")
