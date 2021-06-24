extends WindowDialog

var map : Map

func _ready():
	call_deferred("resize_window")
	map = Map.new($TileMap)
	$Cursor.map = map
	var _connection = get_tree().connect("screen_resized", self, "resize_window")

func resize_window():
	popup(get_viewport_rect())
