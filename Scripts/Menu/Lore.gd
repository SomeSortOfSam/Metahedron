extends Control

signal request_back()

func _on_Back_pressed():
	emit_signal("request_back")
