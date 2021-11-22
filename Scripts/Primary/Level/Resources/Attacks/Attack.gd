extends Resource
class_name Attack

export var icon : Texture = load("res://Assets/Editor Icons/Map.png")
export var name : String = "Sample Attack"
export var description : String = "More defualt text!"

export var friendlyFire : bool = false

export var bitmask : Texture = load("res://Assets/Attack Bitmaps/default.png")
export var distance : int

export var time_to_complete : float
export var projectile : Texture
export var custom_animation : String

func attack(map : Map, center_cell : Vector2, direction : Vector2) -> Array:
	var array = []
	
	var image = bitmask.get_data()
	image.lock()
	
	var orgin = Vector2((image.get_width() / 2), image.get_height() - 1)
	
	for w in image.get_width():
		for h in image.get_height():
			if image.get_pixel(w, h) == Color.red:
				orgin = Vector2(w, h)
			elif image.get_pixel(w, h) == Color.blue:
				array.append(Vector2(w, h))
	
	image.unlock()
	
	for i in array.size():
		array[i] -= orgin
		array[i] += center_cell
	
	return array
