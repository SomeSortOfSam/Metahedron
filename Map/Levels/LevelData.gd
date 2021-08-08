extends TileMap
class_name LevelData

var map : Map

func to_map():
	map = Map.new(self)
	populate_map()

func populate_map():
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

func get_window(cell : Vector2 , popup := true) -> MovementWindow:
	if map.is_occupied(cell):
		var person = map.people[cell]
		var movement_window : MovementWindow = map.get_window(person)
		if !movement_window:
			movement_window = add_movement_window(cell, popup, person)
		if popup:
			movement_window.popup_around_tile(cell)
		return movement_window
	return null

func add_movement_window(cell : Vector2, popup : bool, person):
	map.add_window(MovementWindow.get_window(cell,map,3, popup), person)
	var movement_window = map.get_window(person)
	get_tree().current_scene.add_child(movement_window)
	return movement_window
