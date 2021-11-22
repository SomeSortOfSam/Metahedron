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

func attack(map : Map, center_cell : Vector2, direction : Vector2) -> PoolVector2Array:
	var array := get_bitmask_delta_array()
	array = change_deltas_to_direction(array,direction)
	
	var i := 0
	while i < array.size():
		array[i] += center_cell
		if !Pathfinder.is_walkable(array[i],map):
			array.remove(i)
			i -= 1
		i += 1
	
	return array

func get_bitmask_delta_array() -> PoolVector2Array:
	var array := PoolVector2Array([])
	
	var image := bitmask.get_data()
	image.lock()
	
	var orgin = Vector2((image.get_width() / 2), image.get_height() - 1)
	var new_orgin_found := false
	
	for w in image.get_width():
		for h in image.get_height():
			if image.get_pixel(w, h).r == 1.0:
				if !new_orgin_found:
					orgin = Vector2(w, h)
					new_orgin_found = true
				else:
					return PoolVector2Array([])
			if image.get_pixel(w, h).b == 1.0:
				array.append(Vector2(w, h))
	
	image.unlock()
	
	for i in array.size():
		array[i] -= orgin
	
	return array

func change_deltas_to_direction(delta_array : PoolVector2Array, direction : Vector2) -> PoolVector2Array:
	var right := Vector2(-direction.y,direction.x)
	for i in delta_array.size():
		delta_array[i] = ((delta_array[i].y + distance) * -direction) + (delta_array[i].x * right)
	return delta_array
