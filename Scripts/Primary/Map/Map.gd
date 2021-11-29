extends Reference
class_name Map,"res://Assets/Editor Icons/LevelData.png"
## Storage object for the current game state. Also responsible for populating the display objects

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
	_connection = person.connect("attack", self, "_on_person_attack",[person])
	_connection = person.connect("died", self, "_on_person_died",[person])
	emit_signal("person_added",person)

func _on_person_move(cell_delta,person):
	if people.erase(person.cell - cell_delta):
		people[person.cell] = person

func _on_person_attack(direction : Vector2, attack, source):
	var timer : Timer
	timer = Timer.new()
	timer.connect("timeout", self, "calculate_damage", [direction, attack, source])
	timer.start(attack.time_to_complete)
	print(attack.time_to_complete)

func calculate_damage(direction : Vector2, attack, source):
	print("ok")
	for person in people.values():
		person.calculate_damage(attack,direction,source,self)

func _on_person_died(person):
	var _deleted = people.erase(person.cell)

func add_decoration(decoration):
	decorations.append(decoration)

func repopulate_displays(use_icons := true):
	for child in tile_map.get_children():
		if "definition" in child:
			child.queue_free()
	populate_units(use_icons)
	populate_decoration_displays(use_icons)
	emit_signal("repopulated")

func populate_units(use_icons : bool):
	for cell in people:
		people[cell].to_unit(self, use_icons)

func populate_decoration_displays(use_icons : bool):
	for decoration in decorations:
		decoration.to_decoration_display(self, use_icons) 
