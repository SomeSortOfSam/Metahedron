extends Resource
class_name Attack

export var icon : Texture = load("res://Assets/Editor Icons/Map.png")
export var name : String = "Sample Attack"
export var description : String = "More defualt text!"

export var friendlyFire : bool = false

export var bitmask : Texture
export var distance : int

export var time_to_complete : float
export var projectile : Texture
export var custom_animation : String

func attack(map : Map, center_cell : Vector2, direction : Vector2) -> Array:
	return []