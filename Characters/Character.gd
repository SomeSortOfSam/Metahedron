tool
extends Path2D
class_name Character

signal walk_finished

export var map : Resource = preload("res://Maps/TestMap.tres")
export(int) var map_speed = 3 #Number of tiles the character can move per turn
export(float) var world_speed = 600.0 #Number of pixels per second the character moves on path
export(Texture) var skin setget set_skin

var cell := Vector2.ZERO setget set_cell
var is_selected := false setget set_is_selected
var is_walking := false setget set_is_walking

onready var _sprite: Sprite = $PathFollow2D/Sprite
onready var _animation_player: AnimationPlayer = $PathFollow2D/Sprite/AnimationPlayer
onready var _path_follower: PathFollow2D = $PathFollow2D

func set_skin(new_skin : Texture):
	skin = new_skin
	if not _sprite:
		yield(self, "ready")
	_sprite.texture = new_skin

func set_cell(new_cell : Vector2):
	cell = map.clamp(new_cell)

func set_is_selected(new_is_selected : bool):
	is_selected = new_is_selected
	if is_selected:
		_animation_player.play("test-selected")
	else:
		_animation_player.play("test-idel")

func set_is_walking(new_is_walking : bool):
	is_walking = new_is_walking
	set_process(is_walking)

func _ready() -> void:
	set_process(false) #Make sure we are not following the path
	
	self.cell = map.world_to_map_space(position)
	position = map.map_to_world_space(cell)
	
	if not Engine.editor_hint:
		curve = Curve2D.new()

func _process(delta) -> void:
	_path_follower.offset += world_speed * delta
	
	if _path_follower.unit_offset >= 1.0:
		self.is_walking = false
		_path_follower.offset = 0.0
		position = map.map_to_world_space(cell)
		curve.clear_points()
		emit_signal("walk_finished")

func walk_along(path: PoolVector2Array) -> void:
	print(path)
	if path.empty():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(map.map_to_world_space(point) - position)
	
	cell = path[-1]
	self.is_walking = true
	

