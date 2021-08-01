extends TileMap
class_name LevelData

func to_map() -> Map:
	var map := Map.new(self)
	for child in get_children():
		if child is Unit:
			var person := Person.new(child.character,map)
			person.cell = map.local_to_map(child.position)
			map.add_unit(person)
			child.subscribe(person)
	return map

func add_unit(position : Vector2):
	var new_unit = Unit.new()
	new_unit.position = position
	add_child(new_unit)
