extends Path2D
class_name Unit

export var character : Resource setget set_character
export var is_icon := false setget deffer_set_is_icon
export var speed : float = 10

onready var _follower : PathFollow2D = $Follower
onready var _icon : Sprite = $Follower/Icon
onready var _sprite : AnimatedSprite = $Follower/Sprite

func set_character(new_character : Character):
	assert(new_character is Character || new_character == null, "New character in not of type Character")
	if new_character is Character:
		call_deferred("populate_character",new_character)
	elif new_character == null:
		call_deferred("populate_null_character")

func populate_character(new_character : Character):
	character = new_character
	_icon.texture = character.level_texture
	_icon.position = character.level_offset
	_sprite.frames = character.animations
	_sprite.offset = character.animations_offset

func populate_null_character():
	character = null
	_icon.texture = null
	_sprite.frames = null

func follow_path(path : PoolVector2Array):
	end_follow_path()
	curve = path_to_curve(path)

func path_to_curve(path : PoolVector2Array):
	var new_curve = Curve2D.new()
	var cell_size = (get_parent() as TileMap).cell_size
	for i in path.size():
		new_curve.add_point(path[i] * cell_size)

func _process(delta):
	if curve:
		_follower.offset += delta * speed
		if _follower.unit_offset >= 1:
			end_follow_path()

func end_follow_path():
	_follower.unit_offset = 1
	curve = null
	_follower.offset = 0
	position += _follower.position
	_follower.position = Vector2.ZERO


#pre-onready-null protection
func deffer_set_is_icon(new_is_icon):
	call_deferred("set_is_icon",new_is_icon)

func set_is_icon(new_is_icon : bool):
	is_icon = new_is_icon
	_sprite.visible = !is_icon
	_icon.visible = is_icon

func subscribe(person,map):
	self.character = person.character
	var cell = person.cell
	if "map" in map:
		cell = MapSpaceConverter.internal_map_to_map(cell,map)
	position = MapSpaceConverter.map_to_local(cell,map)
	person.connect("requesting_follow_path", self, "follow_path")
