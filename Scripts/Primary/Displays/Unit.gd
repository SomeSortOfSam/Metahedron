extends Node2D
class_name Unit, "res://Assets/Editor Icons/Unit.png"
## Display object for people

export var speed : float = 10

onready var followe : Path2D = $Path2D
onready var follower : PathFollow2D = $Path2D/Follower
onready var icon : Sprite = $Node2D/Icon
onready var sprite : AnimatedSprite = $Node2D/Sprite
onready var emitter : CPUParticles2D = $Node2D/CPUParticles2D

var definition : Character setget set_character
var is_icon := false setget set_is_icon
var parent_tilemap : TileMap

func set_character(new_character : Character):
	definition = new_character
	icon.texture = definition.level_texture
	icon.position = definition.level_offset
	icon.scale = definition.level_scale
	sprite.frames = definition.animations
	sprite.offset = definition.animations_offset
	sprite.scale = definition.animations_scale

func set_is_icon(new_is_icon : bool):
	is_icon = new_is_icon
	sprite.visible = !is_icon
	icon.visible = is_icon

func _process(delta):
	follow_animation(delta)

func follow_animation(delta):
	if followe.curve:
		follower.offset += delta * speed
		set_sprite_flip()
		out_of_bounds_fadeing_animation()
		if follower.unit_offset >= 1:
			end_on_person_move()

func set_sprite_flip():
	var destination := followe.curve.get_point_position(followe.curve.get_point_count() - 1)
	sprite.flip_h = (destination - follower.position).x < 0

func out_of_bounds_fadeing_animation():
	var cell := parent_tilemap.world_to_map(parent_tilemap.to_local(follower.global_position))
	var tile_type := parent_tilemap.get_cellv(cell)
	if  tile_type < 0:
		modulate.a = lerp(modulate.a,0,.6)
	else:
		modulate.a = lerp(modulate.a,1,.6)

func end_on_person_move():
	follower.unit_offset = 1
	position += follower.position
	end_follow_animation()
	followe.curve = null
	follower.offset = 0
	follower.position = Vector2.ZERO

func end_follow_animation():
	if sprite.frames.has_animation("Idle"):
		sprite.animation = "Idle"
	if followe.curve && parent_tilemap.get_cellv(parent_tilemap.world_to_map(position)) < 0:
		queue_free()

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

func subscribe(person,map):
	self.definition = person.character
	if person.is_evil:
		modulate = Color.red
	var cell = person.cell
	if "map" in map:
		cell = MapSpaceConverter.internal_map_to_map(cell,map)
	position = MapSpaceConverter.map_to_local(cell,map)
	parent_tilemap = map.tile_map
	var _connection = person.connect("move_animation", self, "_on_person_move",[person, map])
	_connection = person.connect("attack", self, "_on_person_attack")
	_connection = person.connect("hurt", self, "_on_person_hurt")
	_connection = person.connect("died", self, "_on_person_died")

func _on_person_move(delta : Vector2, person, map):
	end_on_person_move()
	
	var cell_size = parent_tilemap.cell_size
	if "map" in map && person.cell == map.center_cell:
		position -= delta * cell_size
	
	var cell := parent_tilemap.world_to_map(parent_tilemap.to_local(follower.global_position))
	var tile_type := parent_tilemap.get_cellv(cell)
	modulate.a = 0 if tile_type < 0 else 1
	
	var path := get_follow_path(person.cell - delta,person.cell,map)
	followe.curve = path_to_curve(path,cell_size)

	if sprite.frames.has_animation("Walk"):
		sprite.animation = "Walk"

func _on_person_attack(direction : Vector2, attack : Attack):
	sprite.flip_h = direction.x < 0
	
	sprite.play(attack.custom_animation if sprite.frames.has_animation(attack.custom_animation) else "Attack")
	var _connection = sprite.connect("animation_finished", self, "end_follow_animation", [], CONNECT_ONESHOT)

func _on_person_hurt(delta):
	sprite.play("Hurt")
	emitter.texture.region = Rect2(delta*8,0,8,16)
	emitter.restart()
	var _connection = sprite.connect("animation_finished", self, "end_follow_animation", [], CONNECT_ONESHOT)

func _on_person_died():
	queue_free()
