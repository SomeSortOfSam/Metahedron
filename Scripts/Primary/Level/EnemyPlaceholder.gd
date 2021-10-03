tool
extends Placeholder
class_name EnemyPlaceholder

export var health : int
export var tile_range : int

func get_tool_color() -> Color:
	return Color(0,0,0,TOOL_ALPHA)
