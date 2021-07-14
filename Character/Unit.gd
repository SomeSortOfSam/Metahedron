tool
extends Path2D
class_name Unit

const TOOL_ALPHA := .2

export var friendly := false
export var character : Resource setget set_character
export var in_level_map := false setget set_in_level_map

onready var _icon : Sprite = $PathFollow2D/Sprite
onready var _sprite : AnimatedSprite = $PathFollow2D/AnimatedSprite

var map

func _ready():
	z_index = 2

func set_character(new_characeter : Character):
	grab_onreadys()
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
	grab_onreadys()
	in_level_map = new_in_level_map
	_sprite.visible = !in_level_map
	_icon.visible = in_level_map

func grab_onreadys():
	if _icon == null:
		_icon = $PathFollow2D/Sprite
	if _sprite == null:
		_sprite = $PathFollow2D/AnimatedSprite

func _draw(is_editor := Engine.editor_hint):
	var tilemap := get_parent() as TileMap
	if is_editor && tilemap:
		var color := Color.green if friendly else Color.red
		color.a = TOOL_ALPHA
		position = tilemap.map_to_world(tilemap.world_to_map(position)) + tilemap.cell_size/2
		draw_rect(Rect2(-tilemap.cell_size/2,tilemap.cell_size),color)
