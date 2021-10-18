extends Node
class_name PrimaryLoopBootstrap

export var packed_level_data : PackedScene

onready var turn_gui_holder = $VSplitContainer/UnitGUI
onready var music = $AudioStreamPlayer
onready var cursor = $VSplitContainer/Playspace/Body
onready var map_scaler : MapScaler = $VSplitContainer/Playspace/Body/MapScaler

var map : Map

func _ready():
	var data = validate_level_data(packed_level_data)
	initialize_level(data)
	data.queue_free()

func initialize_level(level_data : LevelData):
	initialize_music(level_data)
	initialize_map(level_data)

func initialize_music(level_data : LevelData):
	music.stream = level_data.music
	music.play() 

func initialize_map(level_data : LevelData):
	map = level_data.to_map()
	map_scaler.tile_map.tile_set = level_data.tile_set
	for cell in level_data.get_used_cells():
		map_scaler.tile_map.set_cell(cell.x,cell.y,level_data.get_cellv(cell),false,false,false,level_data.get_cell_autotile_coord(cell.x,cell.y))
	map.tile_map = map_scaler.tile_map
	map.repopulate_displays()
	cursor.map = map
	populate_turn_gui()

# warning-ignore:shadowed_variable
func validate_level_data(packed_level_data : PackedScene) -> LevelData:
	var unpacked_level_data := packed_level_data.instance() as LevelData
	assert(unpacked_level_data != null, "Level data for " + name + " was not of type level data")
	if unpacked_level_data:
		return unpacked_level_data
	else:
		return LevelData.new()

func _on_Cursor_position_accepted(cell):
	if Pathfinder.is_occupied(cell,map):
		var person : Person = map.people[cell]
		var movement_window = person.window
		if movement_window == null:
			movement_window = person.initialize_window(map)
			cursor.add_child(movement_window)
		if(!person.is_evil):
			movement_window.call_deferred("popup_around_tile")

func populate_turn_gui():
	var turn_gui = turn_gui_holder.get_child(0)
	turn_gui.queue_free()
	for cell in map.people:
		var person = map.people[cell]
		if !person.is_evil:
			var unit_turn_gui = turn_gui.duplicate()
			unit_turn_gui.subscribe(person)
			turn_gui_holder.add_child(unit_turn_gui)
