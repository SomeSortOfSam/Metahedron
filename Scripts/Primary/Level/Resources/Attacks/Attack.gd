extends Resource
class_name Attack

export var icon : Texture = load("res://Assets/Editor Icons/Map.png")
export var name : String = "Sample Attack"
export var description : String = "More defualt text!"

export var friendlyFire : bool = false

export var bitmask : Texture
export var distance : int
export var damage := 1

export var time_to_complete : float = 1
export var projectile : Texture
export var custom_animation : String

func attack(map : Map, center_cell : Vector2, direction : Vector2) -> PoolVector2Array:
	var bitmask_deltas := get_bitmask_delta_array()
	bitmask_deltas = change_deltas_to_direction(bitmask_deltas,direction)
	
	var source_window
	for cell in map.people:
		var person = map.people[cell]
		var window = person.window
		if window.map.center_cell == center_cell:
			source_window = window
			break 

	var out := PoolVector2Array([])
	var tile_size = bitmask.get_size() if bitmask else Vector2.ONE
	for cell in map.people:
		var person = map.people[cell]
		var window = person.window
		if window.visible:
			out = add_windows_cells(out,window,source_window,bitmask_deltas,direction,tile_size)
	
	var i := 0
	while i < out.size():
		if !Pathfinder.is_walkable(out[i],map):
			out.remove(i)
			i -= 1
		i += 1
	
	return out

func add_windows_cells(out : PoolVector2Array, window, source_window, bitmask_deltas : PoolVector2Array, _direction : Vector2, _tile_size : Vector2) -> PoolVector2Array:
	var relative_center = get_realative_center(window,source_window)
	for delta in bitmask_deltas:
		var cell = delta + relative_center
		if Pathfinder.is_cell_in_range(window.map.center_cell,cell,window.map.tile_range):
			out.append(cell)
	return out

func get_realative_center(window, source_window) -> Vector2:
	if window == source_window:
		return source_window.map.center_cell
	var out := MapSpaceConverter.map_to_global(source_window.map.center_cell,source_window.map)
	out = MapSpaceConverter.global_to_map(out,window.map)
	return out

func get_bitmask_delta_array() -> PoolVector2Array:
	var out := PoolVector2Array([])
	
	if bitmask:
		var image := bitmask.get_data()
		image.lock()
		
# warning-ignore:integer_division
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
					out.append(Vector2(w, h))
		
		image.unlock()
		
		for i in out.size():
			out[i] -= orgin
	else:
		out = get_defualt_bitmask_deltas()
	return out

func change_deltas_to_direction(delta_array : PoolVector2Array, direction : Vector2) -> PoolVector2Array:
	var right := Vector2(-direction.y,direction.x)
	for i in delta_array.size():
		delta_array[i] = ((delta_array[i].y + distance) * -direction) + (delta_array[i].x * right)
	return delta_array

func get_defualt_bitmask_deltas() -> PoolVector2Array:
	return PoolVector2Array([Vector2.UP])
