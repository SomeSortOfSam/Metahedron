tool
extends Node2D
class_name DecorationDisplay

export var in_level := true setget set_in_level
export var definition : Resource setget set_definition

var override_in_editor := false
var _sprite : Sprite
var movement_sprite : Sprite

func _init():
	_sprite = Sprite.new()
	add_child(_sprite)

func set_in_level(new_in_level : bool):
	in_level = new_in_level
	if definition:
		_sprite.texture = definition.level_texture if in_level else definition.movement_texture
		_sprite.position = definition.level_offset if in_level else definition.movement_offset

func set_definition(new_definition : DecorationDefinition):
	assert(new_definition is DecorationDefinition || new_definition == null, "New DecorationDefinition in not of type DecorationDefinition")
	if new_definition is DecorationDefinition:
		populate_definition(new_definition)
	elif new_definition == null:
		populate_null_definition()

func populate_definition(new_definition : DecorationDefinition):
	definition = new_definition
	set_in_level(in_level)

func populate_null_definition():
	definition = null
	_sprite.texture = null
	_sprite.position = Vector2.ZERO

func _draw():
	var tilemap := get_parent() as TileMap
	if (Engine.editor_hint || override_in_editor) && tilemap:
		draw_line(tilemap.map_to_world(tilemap.world_to_map(position)),position,Color.white)
