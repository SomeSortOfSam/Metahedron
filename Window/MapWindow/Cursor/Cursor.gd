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
	modulate = Color(1,1,1,0)
	scale = map.tile_map.scale
	scale *= map.tile_map.cell_size / map.tile_map.scale / sprite.get_size()

func set_cell(new_cell : Vector2):
	var clamped_cell = map.clamp(new_cell)
	if map.is_walkable(clamped_cell):
		cell = clamped_cell
	global_position = Pathfinder.map_to_world(map,cell)

func _input(event):
	handle_mouse_event(event)
	handle_keyboard_event(event)
	set_cursor_color()
	if event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)

func handle_mouse_event(event):
	var event_position = Pathfinder.map_to_world(map,cell)
	if event.has_method("get_position"):
		event_position = event.get_position()
	var new_cell = Pathfinder.world_to_map(map,event_position)
	self.cell = new_cell
	out_of_bounds = !cell.is_equal_approx(new_cell)

func handle_keyboard_event(event):
	var should_move : bool = event.is_pressed()
	if event.is_echo():
		should_move = should_move and timer.is_stopped()
	
	if should_move:
		keystroke_to_cell_transform(event)
		if event is InputEventAction:
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
	modulate.a = 1.0 if !out_of_bounds && map.is_walkable(cell) else 0.0
