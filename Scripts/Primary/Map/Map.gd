extends Reference
class_name Map,"res://Assets/Editor Icons/LevelData.png"

var tile_map : TileMap
var astar : AStar2D
var people := {}
var decorations := [] 

signal repopulated()
signal person_added(person)

func _init(new_tilemap : TileMap):
	tile_map = new_tilemap
	astar = Pathfinder.map_to_astar(self)

func clamp(map_point : Vector2) -> Vector2:
	var used_rect := tile_map.get_used_rect()
	map_point.x = clamp(map_point.x, 0, max(used_rect.size.x -1, 1))
	map_point.y = clamp(map_point.y, 0, max(used_rect.size.y -1, 1))
	return map_point

func add_person(person):
	people[person.cell] = person
	var _connection = person.connect("move",self,"_on_person_move",[person])
	emit_signal("person_added",person)

func _on_person_move(cell_delta,person):
	if people.erase(person.cell - cell_delta):
		people[person.cell] = person

func add_decoration(decoration):
	decorations.append(decoration)

func get_person(cell : Vector2):
	if people.has(cell):
		return people[cell]
	return null

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
