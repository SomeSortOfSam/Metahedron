extends WindowDialog
class_name MapWindow

onready var cursor : Cursor
onready var path : Path2D = $Path2D
onready var follower : PathFollow2D = $Path2D/PathFollow2D
onready var tilemap_container : Node2D = $Path2D/PathFollow2D/TilemapContainer
