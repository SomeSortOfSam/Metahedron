extends Control

signal request_back()

func to_settings() -> Settings:
	return Settings.new()

func from_settings(_settings : Settings):
	pass

func _on_Button_pressed():
	emit_signal("request_back")
