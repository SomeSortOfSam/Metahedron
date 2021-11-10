extends Resource
class_name Attack

export var icon : Texture
export var name : String
export var description : String

export var friendlyFire : bool = false

export var bitmask : Texture
export var distance : int

export var time_to_complete : float
export var projectile : Texture
export var custom_animation : String

func attack(map : Map, direction : Vector2) -> Array:
	return []
