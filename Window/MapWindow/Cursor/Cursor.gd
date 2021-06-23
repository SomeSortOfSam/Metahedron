extends Sprite
class_name Cursor

onready var _timer : Timer = $Timer

export(float) var ui_cooldown = .1

var map : Map
var cell : Vector2 setget set_cell

func _init(map : Map):
	self.map = map

func set_cell(new_cell : Vector2):
	cell = map.clamp(new_cell)
	position = map.map_to_world(cell)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.cell = map.world_to_map(event.position)
	
	#keyboard cursor movement
	var should_move : bool = event.is_pressed()
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	
	if not should_move:
		return
	
	if event.is_action("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2.DOWN
