extends Sprite
class_name Cursor

const SPRITE_PATH := "res://Assets/Levels/TileGlow.png"

export(float) var ui_cooldown = .1

var sprite : Texture = preload(SPRITE_PATH)
var _timer : Timer
var map : Map
var cell : Vector2 setget set_cell
var out_of_bounds : bool = false

signal accept_pressed(cell)
signal new_in_bounds
signal confirmed_movement(delta)

func _init(new_map : Map):
	map = new_map
	setup_children()
	setup_texture()
	setup_scale()

func setup_children():
	_timer = Timer.new()
	add_child(_timer)

func setup_texture():
	texture = sprite
	modulate = Color(1,1,1,0)

func setup_scale():
	scale = map.tile_map.scale
	scale *= map.tile_map.cell_size / map.tile_map.scale / sprite.get_size()

func set_cell(new_cell : Vector2):
	var clamped_cell = map.clamp(new_cell)
	if Pathfinder.is_walkable(clamped_cell,map):
		if out_of_bounds:
			emit_signal("new_in_bounds")
		else:
			emit_signal("confirmed_movement",clamped_cell)
		cell = clamped_cell
	
	position = MapSpaceConverter.map_to_local(cell,map)

func _unhandled_input(event):
	handle_mouse_event(event)
	handle_keyboard_event(event)
	set_cursor_color()
	check_accept(event)

func handle_mouse_event(event):
	var event_position = MapSpaceConverter.map_to_global(cell,map)
	if event.has_method("get_position"):
		event_position = event.get_position()
	var new_cell = MapSpaceConverter.global_to_map(event_position,map)
	self.cell = new_cell
	out_of_bounds = !cell.is_equal_approx(new_cell)

func handle_keyboard_event(event):
	var should_move : bool = event.is_pressed()
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	
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
	modulate.a = 1.0 if !out_of_bounds && Pathfinder.is_walkable(cell,map) else 0.0

func check_accept(event):
	if is_accept(event):
		emit_signal("accept_pressed", cell)

func is_accept(event):
	var double : bool = event is InputEventMouseButton 
	if double:
		double = double && event.button_index == 1 
		double = double && event.is_doubleclick()
	return event.is_action_pressed("ui_accept") || double
