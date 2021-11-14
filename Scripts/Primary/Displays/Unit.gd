extends Node2D
class_name Unit, "res://Assets/Editor Icons/Unit.png"
## Display object for people

export var speed : float = 10

onready var _followe : Path2D = $Path2D
onready var _follower : PathFollow2D = $Path2D/Follower
onready var _icon : Sprite = $Node2D/Icon
onready var _sprite : AnimatedSprite = $Node2D/Sprite

var definition : Character setget set_character
var is_icon := false setget deffer_set_is_icon
var parent_tilemap : TileMap

func set_character(new_character : Character):
	definition = new_character
	_icon.texture = definition.level_texture
	_icon.position = definition.level_offset
	_icon.scale = definition.level_scale
	_sprite.frames = definition.animations
	_sprite.offset = definition.animations_offset
	_sprite.scale = definition.animations_scale

func _on_person_move(delta : Vector2, person, map):
	end_on_person_move()
	
	var cell_size = parent_tilemap.cell_size
	if "map" in map && person.cell - delta == Vector2.ZERO:
		position -= delta * cell_size
	
	var path := get_follow_path(person.cell - delta,person.cell,map)
	_followe.curve = path_to_curve(path,cell_size)

	if _sprite.frames.has_animation("Walk"):
		_sprite.animation = "Walk"

func get_follow_path(from : Vector2, to : Vector2, map) -> PoolVector2Array:
	if "map" in map:
		map = map.map

	var from_index = MapSpaceConverter.map_to_index(from)
	var to_index = MapSpaceConverter.map_to_index(to)

	var path : PoolVector2Array = map.astar.get_point_path(from_index,to_index)
	for i in path.size(): # make from 0
		path[i] -= from

	return path

func path_to_curve(path : PoolVector2Array, cell_size : Vector2) -> Curve2D:
	var new_curve = Curve2D.new()
	for i in path.size():
		new_curve.add_point(path[i] * cell_size)
	return new_curve

func _process(delta):
	follow_animation(delta)

func follow_animation(delta):
	if _followe.curve:
		_follower.offset += delta * speed
		set_sprite_flip()
		out_of_bounds_fadeing_animation()
		if _follower.unit_offset >= 1:
			end_on_person_move()

func set_sprite_flip():
	var destination := _followe.curve.get_point_position(_followe.curve.get_point_count() - 1)
	_sprite.flip_h = (destination - _follower.position).x < 0

func out_of_bounds_fadeing_animation():
	var cell := parent_tilemap.world_to_map(parent_tilemap.to_local(_follower.global_position))
	var tile_type := parent_tilemap.get_cellv(cell)
	if  tile_type < 0:
		modulate.a = lerp(modulate.a,0,.6)
	else:
		modulate.a = lerp(modulate.a,1,.6)

func end_on_person_move():
	_follower.unit_offset = 1
	position += _follower.position
	end_follow_animation()
	_followe.curve = null
	_follower.offset = 0
	_follower.position = Vector2.ZERO

func end_follow_animation():
	if _sprite.frames.has_animation("Idle"):
		_sprite.animation = "Idle"
	if _followe.curve && parent_tilemap.get_cellv(parent_tilemap.world_to_map(position)) < 0:
		queue_free()

#pre-onready-null protection
func deffer_set_is_icon(new_is_icon):
	call_deferred("set_is_icon",new_is_icon)

func set_is_icon(new_is_icon : bool):
	is_icon = new_is_icon
	_sprite.visible = !is_icon
	_icon.visible = is_icon

func subscribe(person,map):
	self.definition = person.character
	var cell = person.cell
	if "map" in map:
		cell = MapSpaceConverter.internal_map_to_map(cell,map)
	position = MapSpaceConverter.map_to_local(cell,map)
	parent_tilemap = map.tile_map
	person.connect("move", self, "_on_person_move",[person, map])
