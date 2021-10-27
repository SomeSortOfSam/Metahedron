extends Reference
class_name Map

var tile_map : TileMap
var people := {}
var decorations := [] 

var num_units_with_turn := 0 setget set_num_turns
var evil_turn := false

signal repopulated
signal friendly_turn_ended(evil_turn)
signal evil_turn_ended(evil_turn)

func _init(new_tilemap : TileMap):
	tile_map = new_tilemap

func clamp(map_point : Vector2) -> Vector2:
	var used_rect := tile_map.get_used_rect()
	map_point.x = clamp(map_point.x, 0, max(used_rect.size.x -1, 1))
	map_point.y = clamp(map_point.y, 0, max(used_rect.size.y -1, 1))
	return map_point

func add_person(person):
	people[person.cell] = person
	var _connection = person.connect("cell_change",self,"_on_person_cell_change",[person])
	_connection = person.connect("new_turn",self,"_on_person_new_turn")
	_connection = person.connect("has_set_end_turn",self,"_on_person_has_set_end_turn")
	_connection = connect("evil_turn_ended",person,"reset_turn")

func _on_person_cell_change(cell_delta,person):
	if people.erase(person.cell - cell_delta):
		people[person.cell] = person

func _on_person_new_turn():
	self.num_units_with_turn += 1

func _on_person_has_set_end_turn(ending_turn):
	self.num_units_with_turn -= 1 if ending_turn else -1 

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

func set_num_turns(new_num_turns):
	num_units_with_turn = new_num_turns
	if num_units_with_turn <= 0:
		evil_turn = true
		emit_signal("friendly_turn_ended",evil_turn)
		print("SIGNAL EMITTED " + String(evil_turn))
		
func end_evil_turn():
	evil_turn = false
	emit_signal("evil_turn_ended",evil_turn)
