tool
extends Node2D
class_name Cursor

signal accept_pressed(cell)
signal moved(new_cell)

export var map: Resource = preload("res://Maps/TestMap.tres")
export var ui_cooldown := 0.1

var cell := Vector2.ZERO setget set_cell

onready var _timer: Timer = $Timer
onready var _text : RichTextLabel = $RichTextLabel

func set_cell(new_cell : Vector2):
	var new_cell_clamped : Vector2 = map.clamp(new_cell)
	if not new_cell_clamped.is_equal_approx(cell):
		cell = new_cell_clamped
		
		position = map.map_to_world_space(cell)
		emit_signal("moved",cell)
		_timer.start()
		_text.text = str(cell)

func _ready():
	_timer.wait_time = ui_cooldown
	position = map.map_to_world_space(cell)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		self.cell = map.world_to_map_space(event.position)
	elif event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)
		get_tree().set_input_as_handled()
	
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

func _draw():
	draw_rect(Rect2(-map.cell_size / 2, map.cell_size),self_modulate,false,2.0)
