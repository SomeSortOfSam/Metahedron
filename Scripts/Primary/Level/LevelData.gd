tool
extends TileMap
class_name LevelData, "res://Assets/Editor Icons/LevelData.png"

export var music : AudioStream

func _init():
	tile_set = load("res://Assets/Levels/Tileset.tres")
	cell_size = Vector2.ONE * 16
	scale = Vector2.ONE * 4

func to_map(tilemap : TileMap = self) -> Map:
	var map = Map.new(tilemap)
	populate_map(map)
	return map

func populate_map(map : Map):
	for child in get_children():
		if child is Placeholder:
			add_placeholder(child,map)
	if map.tile_map != self:
		map.tile_map.tile_set = tile_set
		for cell in get_used_cells():
			map.tile_map.set_cell(cell.x,cell.y,get_cellv(cell),false,false,false,get_cell_autotile_coord(cell.x,cell.y))
		map.astar = Pathfinder.map_to_astar(map)

func add_placeholder(placeholder : Placeholder,map):
	if placeholder.definition is DecorationDefinition:
		add_decoration(placeholder, map)
	else:
		add_person(placeholder, map)

func add_person(placeholder : Placeholder, map : Map):
	map.add_person(Person.new(placeholder.definition,placeholder is EnemyPlaceholder,MapSpaceConverter.local_to_map(placeholder.position,map)))

func add_decoration(placeholder : Placeholder, map : Map):
	var decoration = DecorationInstance.new(placeholder.definition)
	decoration.cell = MapSpaceConverter.local_to_map(placeholder.position,map)
	decoration.offset = placeholder.cell_offset
	map.add_decoration(decoration)
