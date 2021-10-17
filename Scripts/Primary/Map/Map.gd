extends Reference
class_name Map

var tile_map : TileMap
var people := {}
var decorations := [] 

signal repopulated

func _init(new_tilemap : TileMap):
	tile_map = new_tilemap

func clamp(map_point : Vector2) -> Vector2:
	var used_rect := tile_map.get_used_rect()
	map_point.x = clamp(map_point.x, 0, max(used_rect.size.x -1, 1))
	map_point.y = clamp(map_point.y, 0, max(used_rect.size.y -1, 1))
	return map_point

func add_person(person):
	people[person.cell] = person
	var _connection = person.connect("cell_change",self,"on_person_cell_change",[person])

func on_person_cell_change(cell_delta,person):
	if people.erase(person.cell - cell_delta):
		people[person.cell] = person

func add_decoration(decoration):
	decorations.append(decoration)

func get_person(cell : Vector2):
	if people.has(cell):
		return people[cell]
	return null

func remove_person(person):
	var _person =people.erase(person.cell)

func remove_decoration(decoration):
	decorations.remove(decoration)

func repopulate_displays():
	for child in tile_map.get_children():
		if "definition" in child:
			child.queue_free()
	populate_units()
	populate_decoration_displays()
	emit_signal("repopulated")

func populate_units():
	for cell in people:
		people[cell].to_unit(self, true)

func populate_decoration_displays():
	for decoration in decorations:
		decoration.to_decoration_display(self, true) 
