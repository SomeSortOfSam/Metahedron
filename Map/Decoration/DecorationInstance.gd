extends Reference
class_name DecorationInstance

var definition : DecorationDefinition
var cell : Vector2
var offset : Vector2

func _init(new_definition : DecorationDefinition):
	definition = new_definition

func to_decoration_display(map : Map, in_level : bool):
	var display := DecorationDisplay.new()
	display.definition = definition
	display.position = MapSpaceConverter.map_to_local(cell,map) + offset
	display.in_level = in_level
	map.tile_map.add_child(display)
