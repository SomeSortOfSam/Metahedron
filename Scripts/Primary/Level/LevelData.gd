tool
extends TileMap
class_name LevelData

export var music : AudioStream

func _init():
	tile_set = load("res://Assets/Levels/Tileset.tres")
	cell_size = Vector2.ONE * 16
	scale = Vector2.ONE * 4

func to_map() -> Map:
	var map = Map.new(self)
	populate_map(map)
	return map

func populate_map(map):
	for child in get_children():
		if child is Placeholder:
			add_placeholder(child,map)

func add_placeholder(placeholder : Placeholder,map):
	if placeholder.definition is DecorationDefinition:
		add_decoration(placeholder, map)
	else:
		add_person(placeholder, map)

func add_person(placeholder : Placeholder, map : Map):
	map.add_person(Person.new(placeholder.definition,placeholder is EnemyPlaceholder,MapSpaceConverter.local_to_map(placeholder.position,map)))

func add_decoration(placeholder : Placeholder, map : Map):
	var decoration = DecorationInstance.new(placeholder.definition)
	decoration.cell = MapSpaceConverter.local_to_map(placeholder.position,map)
	decoration.offset = placeholder.cell_offset
	map.add_decoration(decoration)
