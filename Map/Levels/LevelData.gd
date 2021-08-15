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
		if child is DecorationDisplay:
			add_decoration(child,map)

func add_unit(position : Vector2):
	var new_unit = Unit.new()
	new_unit.position = position
	add_child(new_unit)

func add_person(child : Unit, map : Map):
	var person := Person.new(child.character)
	person.cell = map.local_to_map(child.position)
	map.add_person(person)
	child.subscribe(person,map)

func add_decoration(child : DecorationDisplay, map : Map):
	map.add_decoration(child)
	child.in_level = true
