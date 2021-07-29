extends Reference
class_name Map

var tile_map : TileMap
var units := {}
var decorations := {}

func _init(new_tilemap : TileMap):
	tile_map = new_tilemap

func get_used_rect() -> Rect2:
	return tile_map.get_used_rect()

func is_occupied(map_point : Vector2) -> bool:
	return units.has(map_point)

func is_walkable(map_point : Vector2) -> bool:
	var tile_map_point := map_point + get_used_rect().position
	var tile_type = tile_map.get_cellv(tile_map_point)
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
	return tile_type != -1 && is_tile_type_walkable(tile_type, tile_map.get_cell_autotile_coord(tile_map_point.x,tile_map_point.y))

func is_tile_type_walkable(tile_type : int, autotile_coords : Vector2 = Vector2.ZERO) -> bool:
	if tile_map.tile_set && tile_map.tile_set.get_tiles_ids().find(tile_type) != -1:
		if tile_map.tile_set.tile_get_tile_mode(tile_type) == TileSet.SINGLE_TILE:
			return is_single_tile_type_walkable(tile_type)
		else:
			return is_autotile_type_walkable(tile_type,autotile_coords)
	return true

func is_single_tile_type_walkable(tile_type : int) -> bool:
	if tile_map.tile_set:
		return tile_map.tile_set.tile_get_shape_count(tile_type) <= 0
	return true

func is_autotile_type_walkable(tile_type : int, autotile_coords : Vector2) -> bool:
	if tile_map.tile_set:
		for dic in tile_map.tile_set.tile_get_shapes(tile_type):
			if dic["autotile_coord"] == autotile_coords:
				return false
		return true
	return true

func get_walkable_tiles() -> Array:
	var out := []
	var used_rect = get_used_rect()
	for x in used_rect.size.x:
		for y in used_rect.size.y:
			var tile := Vector2(x,y)
			if is_walkable(tile):
				out.append(tile)
	return out

func get_walkable_tiles_in_range(map_point : Vector2, tile_range : int) -> Array:
	var out := get_walkable_tiles()
	for i in out.size():
		var point = out[i]
		if abs(map_point.x - point.x) > tile_range or abs(map_point.y - point.y) > tile_range :
			out.remove(i)
			i -= 1
	return out

func clamp(map_point : Vector2) -> Vector2:
	var used_rect := get_used_rect()
	map_point.x = clamp(map_point.x, 0, used_rect.size.x - 1 )
	map_point.y = clamp(map_point.y, 0, used_rect.size.y - 1)
	return map_point

func get_unit_window(unit):
	var dict = units[unit.cell]
	return dict.window

func add_unit(unit):
	unit.map = self
	var dict = {"unit" : unit, "window" : null}
	units[unit.cell] = dict

func add_window(window, unit):
	var dict = units[unit.cell]
	dict.window = window
	units[unit.cell] = dict

func remove_unit(unit):
# warning-ignore:return_value_discarded
	units.erase(unit.cell)

func add_decoration():
	pass

func map_to_index(map_point : Vector2) -> int:
	return int(map_point.y * get_used_rect().size.x + map_point.x)

func map_to_tilemap(map_point : Vector2) -> Vector2:
	return map_point + get_used_rect().position

func tilemap_to_map(tilemap_point : Vector2) -> Vector2:
	return tilemap_point - get_used_rect().position

func map_to_local(map_point : Vector2) -> Vector2:
	return tile_map.map_to_world(map_to_tilemap(map_point)) + tile_map.cell_size/2

func local_to_map(local_point : Vector2) -> Vector2:
	return tilemap_to_map(tile_map.world_to_map(local_point))

func map_to_global(map_point : Vector2) -> Vector2:
	return map_to_local(map_point) * tile_map.scale + tile_map.global_position

func global_to_map(global_point : Vector2) -> Vector2:
	return local_to_map((global_point - tile_map.global_position)/ tile_map.scale) 
