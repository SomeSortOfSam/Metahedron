tool
extends Placeholder
class_name EnemyPlaceholder, "res://Assets/Editor Icons/EnemyPlaceholder.png"
## Level creation object specifically for hostile units

export var health : int
export var tile_range : int
export var attacks : Array = [Attack.new(),Attack.new(),Attack.new()]

func get_tool_color() -> Color:
	return Color(0,0,0,TOOL_ALPHA)
