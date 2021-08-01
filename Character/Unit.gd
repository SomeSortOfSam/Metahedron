tool
extends Path2D
class_name Unit

const TOOL_ALPHA := .2

export var friendly := false
export var character : Resource setget set_character
export var in_level_map := false setget set_in_level_map
var override_in_editor := false

onready var _follower : PathFollow2D
onready var _icon : Sprite
onready var _sprite : AnimatedSprite

func _init():
	curve = null
	_follower = PathFollow2D.new()
	add_child(_follower)
	_icon = Sprite.new()
	_sprite = AnimatedSprite.new()
	_follower.add_child(_icon)
	_follower.add_child(_sprite)

func set_character(new_characeter : Character):
	assert(new_characeter is Character || new_characeter == null, "New character in not of type Character")
	if new_characeter is Character:
		character = new_characeter
		_icon.texture = character.icon
		_icon.position = character.icon_offset
		_sprite.position = character.animations_offset
	elif new_characeter == null:
		character = null
		_icon.texture = null
		_icon.position = Vector2.ZERO
		_sprite.position = Vector2.ZERO

func set_in_level_map(new_in_level_map : bool):
	in_level_map = new_in_level_map
	_sprite.visible = !in_level_map
	_icon.visible = in_level_map

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

func _draw():
	var tilemap := get_parent() as TileMap
	if (Engine.editor_hint || override_in_editor) && tilemap:
		var color := Color.green if friendly else Color.red
		color.a = TOOL_ALPHA
		draw_rect(Rect2(-tilemap.cell_size/2,tilemap.cell_size),color)

func subscribe(person : Person):
	self.character = person.character
	position = person.map.map_to_local(person.cell)
