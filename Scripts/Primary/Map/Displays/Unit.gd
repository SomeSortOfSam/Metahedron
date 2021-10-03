extends Path2D
class_name Unit

export var character : Resource setget set_character
export var is_icon := false setget deffer_set_is_icon

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

#Called when a Person is moved, moves the associated icon as well
func move_cell(offset : Vector2):
	position += offset * 16

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
	person.connect("cell_change", self, "move_cell")
