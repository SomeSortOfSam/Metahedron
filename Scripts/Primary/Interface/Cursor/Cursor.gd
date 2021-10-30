extends Sprite
class_name Cursor

onready var _timer : Timer = $Timer

var in_bounds := false
var map : Map

func setup_scale():
	scale = map.tile_map.scale
	scale *= map.tile_map.cell_size / map.tile_map.scale / texture.get_size()

func draw_display(cell : Vector2, acceptable : bool):
	if acceptable:
		position = MapSpaceConverter.map_to_local(cell,map)
	in_bounds = acceptable
	_timer.start()

func _on_map_change(new_map):
	map = new_map
	setup_scale()

func _on_Timer_timeout():
	modulate.a = 1 if in_bounds else 0
