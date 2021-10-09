extends Map
class_name ReferenceMap

var map : Map
var center_cell : Vector2
var tile_range : int

func _init(new_tile_map : TileMap, new_map : Map, new_center_cell : Vector2, new_tile_range : int).(new_tile_map):
	map = new_map
	center_cell = new_center_cell
	tile_range = new_tile_range
	repopulate_fields()

func repopulate_fields():
	repopulate_people()
	repopulate_decoration_instances()

func repopulate_displays():
	repopulate_tilemap()
	.repopulate_displays() # call map.repopulate displays

func populate_units():
	for cell in people:
		people[cell].to_unit(self, false)

func populate_decoration_displays():
	for decortation in decorations:
		decortation.to_decoration_display(self,false)

func repopulate_people():
	for cell in people.keys():
		people[cell].disconnect("cell_change",self,"on_person_cell_change")
	people.clear()
	for internal_cell in map.people.keys():
		var cell = MapSpaceConverter.internal_map_to_map(internal_cell, self)
		if Pathfinder.is_cell_in_range(Vector2.ZERO, cell, tile_range):
			add_person(map.people[internal_cell])

func repopulate_decoration_instances():
	decorations.clear()
	for decoration in map.decorations:
		var cell = MapSpaceConverter.internal_map_to_map(decoration.cell, self)
		if Pathfinder.is_cell_in_range(Vector2.ZERO, cell, tile_range):
			add_decoration(decoration)

func repopulate_tilemap():
	tile_map.clear()
	var internal_map_tiles = Pathfinder.get_walkable_tiles_in_range(center_cell,tile_range,map)
	for internal_tile in internal_map_tiles:
		populate_tile(internal_tile)

func populate_tile(internal_tile : Vector2):
	var internal_tilemap_tile = MapSpaceConverter.map_to_tilemap(internal_tile,map)
	var internal_tile_type = map.tile_map.get_cellv(internal_tilemap_tile)
	var internal_tile_autotile_coords = map.tile_map.get_cell_autotile_coord(internal_tilemap_tile.x, internal_tilemap_tile.y)
	var tile = MapSpaceConverter.internal_map_to_map(internal_tile,self)
# warning-ignore:narrowing_conversion
	tile_map.set_cell(tile.x, tile.y,clamp(internal_tile_type - 1,0,100),false,false,false,internal_tile_autotile_coords)

func clamp(map_point : Vector2) -> Vector2:
	map_point.x = clamp(map_point.x, -tile_range, tile_range)
	map_point.y = clamp(map_point.y, -tile_range, tile_range)
	return map_point

func add_person(person):
	people[MapSpaceConverter.internal_map_to_map(person.cell,self)] = person
	var _connection = person.connect("cell_change",self,"on_person_cell_change",[person])

func on_person_cell_change(cell_delta,person):
	if people.erase(MapSpaceConverter.internal_map_to_map(person.cell - cell_delta,self)):
		people[MapSpaceConverter.internal_map_to_map(person.cell,self)] = person
	if !Pathfinder.is_cell_in_range(center_cell,person.cell - cell_delta,tile_range) && Pathfinder.is_cell_in_range(center_cell,person.cell,tile_range):
		var unit = person.to_unit(self, false)
		unit.position -= cell_delta * tile_map.cell_size
