extends TileMap
class_name LevelData

func to_map():
	var map = Map.new(self)
	populate_map(map)
	return map

func populate_map(map):
	for child in get_children():
		if child is Unit:
			add_person(child,map)
		elif child is DecorationDisplay:
			add_decoration(child,map)

func add_unit(position : Vector2):
	var new_unit = Unit.new()
	new_unit.position = position
	add_child(new_unit)

func add_person(child : Unit, map : Map):
	var person := Person.new(child.character)
	person.cell = MapSpaceConverter.local_to_map(child.position,map)
	map.add_person(person)

func add_decoration(child : DecorationDisplay, map : Map):
	var decoration = DecorationInstance.new(child.definition)
	decoration.cell = MapSpaceConverter.local_to_map(child.position - child.definition.level_offset,map)
	decoration.offset = child.position - MapSpaceConverter.map_to_local(decoration.cell,map)
	map.add_decoration(decoration)
