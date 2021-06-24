extends Sprite
class_name Cursor

onready var _timer : Timer = $Timer

export(float) var ui_cooldown = .1

var map : Map
var cell : Vector2 setget set_cell

func _init(new_map : Map = Map.new()):
	map = new_map

func set_cell(new_cell : Vector2):
	var clamped_cell = map.clamp(new_cell)
	if map.is_walkable(clamped_cell):
		cell = clamped_cell
	position = map.map_to_world(cell)

func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_event(event)
	handle_keyboard_event(event)

func handle_mouse_event(event : InputEventMouseMotion):
	var new_cell = map.world_to_map(event.position)
	self.cell = new_cell
	modulate = Color.white if map.is_walkable(new_cell) else Color(1,1,1,0)

func handle_keyboard_event(event):
	var should_move : bool = event.is_pressed()
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	
	if should_move:
		modulate = Color.white
		keystroke_to_cell_transform(event)

func keystroke_to_cell_transform(event):
	if event.is_action("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2.DOWN
