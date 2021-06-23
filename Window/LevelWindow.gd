extends WindowDialog

var map : Map

func _ready():
	resize_window()
	map = Map.new($TileMap)
	get_tree().connect("screen_resized",self, "resize_window")

func resize_window():
	popup(get_viewport_rect())
