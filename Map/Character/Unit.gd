tool
extends Path2D
class_name Unit

export var friendly := false
export var character : Resource setget set_character
export var is_icon := false setget set_is_icon
var override_in_editor := false

onready var _follower : PathFollow2D
onready var _icon : Sprite
onready var _sprite : AnimatedSprite

func _init():
	curve = null
	populate_onreadies()
	parent_onreadies()

func populate_onreadies():
	_follower = PathFollow2D.new()
	_icon = Sprite.new()
	_sprite = AnimatedSprite.new()

func parent_onreadies():
	add_child(_follower)
	_follower.add_child(_icon)
	_follower.add_child(_sprite)

func set_character(new_character : Character):
	assert(new_character is Character || new_character == null, "New character in not of type Character")
	if new_character is Character:
		populate_character(new_character)
	elif new_character == null:
		populate_null_character()

func populate_character(new_character : Character):
	character = new_character
	_icon.texture = character.icon
	_icon.position = character.icon_offset
	_sprite.position = character.animations_offset
	_sprite.frames = character.animations
	_sprite.playing = true

func populate_null_character():
	character = null
	_icon.texture = null
	_icon.position = Vector2.ZERO
	_sprite.position = Vector2.ZERO
	_sprite.frames = null

func set_is_icon(new_is_icon : bool):
	is_icon = new_is_icon
	_sprite.visible = !is_icon
	_icon.visible = is_icon

func align_to_tilemap(position : Vector2, tilemap : TileMap) -> Vector2:
	var aligned_pos := tilemap.map_to_world(tilemap.world_to_map(position))
	return aligned_pos + tilemap.cell_size/2

#align to grid
func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		var tilemap := get_parent() as TileMap
		if (Engine.editor_hint || override_in_editor) && tilemap:
			set_notify_transform(false)
			position = align_to_tilemap(position,tilemap)
			set_notify_transform(true)

func get_tool_color() -> Color:
	var color := Color.green if friendly else Color.red
	color.a = DisplayUtilies.TOOL_ALPHA
	return color

func get_offset() -> Vector2:
	return Vector2.ZERO

func _draw():
	DisplayUtilies.draw_index_rect(self)

func subscribe(person,map):
	self.character = person.character
	position = MapSpaceConverter.map_to_local(person.cell,map)
