extends Sprite
class_name Cursor

signal accept_pressed(cell)

const SPRITE_PATH := "res://Window/MapWindow/Cursor/TileGlow.png"

var sprite : Texture = preload(SPRITE_PATH)

var timer : Timer

export(float) var ui_cooldown = .1

var map : Map
var cell : Vector2 setget set_cell
var out_of_bounds : bool = false

func _init(new_map : Map):
	map = new_map
	timer = Timer.new()
	add_child(timer)
	texture = sprite
	scale = map.tile_map.scale
	scale *= map.tile_map.cell_size / sprite.get_size()
	show_behind_parent = true

func set_cell(new_cell : Vector2):
	var clamped_cell = map.clamp(new_cell)
	if map.is_walkable(clamped_cell):
		cell = clamped_cell
	global_position = map.map_to_world(cell)

func _input(event):
	if event is InputEventMouseMotion:
		handle_mouse_event(event)
	elif event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)
	handle_keyboard_event(event)
	set_cursor_color()

func handle_mouse_event(event : InputEventMouseMotion):
	var new_cell = map.world_to_map(event.position)
	self.cell = new_cell
	out_of_bounds = !cell.is_equal_approx(new_cell)

func handle_keyboard_event(event):
	var should_move : bool = event.is_pressed()
	if event.is_echo():
		should_move = should_move and timer.is_stopped()
	
	if should_move:
		keystroke_to_cell_transform(event)
		out_of_bounds = false

func keystroke_to_cell_transform(event):
	if event.is_action("ui_right"):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_up"):
		self.cell += Vector2.UP
	elif event.is_action("ui_left"):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_down"):
		self.cell += Vector2.DOWN

func set_cursor_color():
	modulate = Color.white if !out_of_bounds && map.is_walkable(cell) else Color(1,1,1,0)
