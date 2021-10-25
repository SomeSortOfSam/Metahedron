extends Control

onready var volume : HSlider = $Settings/Volume/HSlider
onready var full_map : CheckBox = $Settings/FullMap/CheckBox
onready var square_window : CheckBox = $Settings/SquareWindow/CheckBox

signal request_back()

func _ready():
	from_settings(Settings.new())

func to_settings():
	var settings = Settings.new()
	settings.volume = volume.value
	settings.fullMap = full_map.pressed
	settings.squareWindows = square_window.pressed
	settings.save()

func from_settings(settings : Settings):
	volume.value = settings.volume
	full_map.pressed = settings.fullMap
	square_window.pressed = settings.squareWindows

func _on_Button_pressed():
	to_settings()
	emit_signal("request_back")
