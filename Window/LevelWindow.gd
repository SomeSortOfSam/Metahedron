extends WindowDialog

var map : Map

func _ready():
	popup(get_viewport_rect())
	map = Map.new($TileMap)
