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
	units.erase(unit.cell)

func add_decoration():
	pass
