extends Map
class_name ReferenceMap

var map : Map
var center_cell : Vector2
var tile_range : int

func _init(new_tile_map : TileMap, new_map : Map, new_center_cell : Vector2, new_tile_range : int).(new_tile_map):
	map = new_map
	center_cell = new_center_cell
	tile_range = new_tile_range
	populate_people()
	populate_decoration_instances()

func repopulate_displays():
	populate_tilemap()
	.repopulate_displays() # call map.repopulate displays

func populate_units():
	for cell in people:
		people[cell].to_unit(self, false)

func populate_decoration_display():
	for decortation in decorations:
		decortation.to_decoration_display(self,false)

func populate_people():
	for internal_cell in map.people.keys():
		var cell = MapSpaceConverter.internal_map_to_map(internal_cell, self)
		if Pathfinder.is_cell_in_range(center_cell, cell, tile_range):
			people[cell] = map.people[internal_cell]

func populate_decoration_instances():
	for decoration in map.decorations:
		var cell = MapSpaceConverter.internal_map_to_map(decoration.cell, self)
		if Pathfinder.is_cell_in_range(center_cell, cell, tile_range):
			decorations.append(decoration)

func populate_tilemap():
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
