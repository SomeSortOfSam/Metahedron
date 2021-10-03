extends Sprite
class_name DecorationDisplay

export var in_level := true setget set_in_level
export var definition : Resource setget set_definition

func set_in_level(new_in_level : bool):
	in_level = new_in_level
	if definition:
		texture = definition.level_texture if in_level else definition.movement_texture
		offset = definition.level_offset if in_level else definition.movement_offset

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
	texture = null
	position = Vector2.ZERO
