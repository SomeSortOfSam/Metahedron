extends Path2D
class_name Unit

export var definition : Resource setget set_character
export var is_icon := false setget deffer_set_is_icon
export var speed : float = 10

onready var _follower : PathFollow2D = $Follower
onready var _icon : Sprite = $Follower/Icon
onready var _sprite : AnimatedSprite = $Follower/Sprite

func set_character(new_character : Character):
	assert(new_character is Character || new_character == null, "New definition in not of type Character")
	if new_character is Character:
		call_deferred("populate_character",new_character)
	elif new_character == null:
		call_deferred("populate_null_character")

func populate_character(new_character : Character):
	definition = new_character
	_icon.texture = definition.level_texture
	_icon.position = definition.level_offset
	_sprite.frames = definition.animations
	_sprite.offset = definition.animations_offset

func populate_null_character():
	definition = null
	_icon.texture = null
	_sprite.frames = null

#pre-onready-null protection
func follow_path_deferred(path : PoolVector2Array):
	call_deferred("follow_path", path)

func follow_path(path : PoolVector2Array):
	end_follow_path()
	var cell_size = (get_parent() as TileMap).cell_size
	if position == Vector2.ONE * 8: # If at the center of a movement window
		position -= path[path.size()-1] * cell_size
	curve = path_to_curve(path,cell_size)
	if _sprite.frames.has_animation("Walk"):
		_sprite.animation = "Walk"

func path_to_curve(path : PoolVector2Array, cell_size : Vector2) -> Curve2D:
	var new_curve = Curve2D.new()
	for i in path.size():
		new_curve.add_point(path[i] * cell_size)
	return new_curve

func _process(delta):
	if curve:
		_follower.offset += delta * speed
		follow_animation()
		if _follower.unit_offset >= 1:
			end_follow_path()

func follow_animation():
	_sprite.flip_h = (curve.get_point_position(curve.get_point_count() - 1) - _follower.position).x < 0
	var parent : TileMap  = get_parent()
	if parent && parent.get_cellv(parent.world_to_map(parent.to_local(_follower.global_position))) < 0:
		modulate.a = lerp(modulate.a,0,.6)
	else:
		modulate.a = lerp(modulate.a,1,.6)

func end_follow_path():
	_follower.unit_offset = 1
	position += _follower.position
	end_follow_animation()
	curve = null
	_follower.offset = 0
	_follower.position = Vector2.ZERO


func end_follow_animation():
	if _sprite.frames.has_animation("Idle"):
		_sprite.animation = "Idle"
	var parent : TileMap  = get_parent()
	if curve && parent.get_cellv(parent.world_to_map(position)) < 0:
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
	person.connect("requesting_follow_path", self, "follow_path_deferred")
