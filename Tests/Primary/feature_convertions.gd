extends "res://addons/gut/test.gd"
class_name ConversionTests
const MAP_SIZE := 5


class Test_map_to_local:
	extends "res://addons/gut/test.gd"
		
	func create_test_map(offset : Vector2 = Vector2.ZERO, parent : Node2D = null, parent_squared : Node2D = null)-> Map:
		var map = Map.new(parent_autofreed_tilemap(parent,parent_squared))
		map.tile_map.cell_size = Vector2.ONE
		for x in MAP_SIZE:
			for y in MAP_SIZE:
				map.tile_map.set_cell(x + offset.x,y + offset.y,0)
		return map

	func parent_autofreed_tilemap(parent : Node2D, parent_squared : Node2D)-> TileMap:
		var tile_map = TileMap.new()
		if parent_squared:
			add_child_autofree(parent_squared)
			parent_squared.add_child(parent)
			parent.add_child(tile_map)
		elif parent:
			add_child_autofree(parent)
			parent.add_child(tile_map)
		else:
			add_child_autofree(tile_map)
		return tile_map
	
	func test_nominal():
		var map := create_test_map()
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO, parent)
		#Act
		parent.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent)
		#Act
		parent.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_offset():
		#setup and act
		var map := create_test_map(Vector2.ONE * 2)
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_cell_size():
		#setup
		var map := create_test_map()
		#act
		map.tile_map.cell_size += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_local(cell,map), cell * 3 + map.tile_map.cell_size/2)

class Test_map_to_global:
	extends "res://addons/gut/test.gd"
		
	func create_test_map(offset : Vector2 = Vector2.ZERO, parent : Node2D = null, parent_squared : Node2D = null)-> Map:
		var map = Map.new(parent_autofreed_tilemap(parent,parent_squared))
		map.tile_map.cell_size = Vector2.ONE
		for x in MAP_SIZE:
			for y in MAP_SIZE:
				map.tile_map.set_cell(x + offset.x,y + offset.y,0)
		return map

	func parent_autofreed_tilemap(parent : Node2D, parent_squared : Node2D)-> TileMap:
		var tile_map = TileMap.new()
		if parent_squared:
			add_child_autofree(parent_squared)
			parent_squared.add_child(parent)
			parent.add_child(tile_map)
		elif parent:
			add_child_autofree(parent)
			parent.add_child(tile_map)
		else:
			add_child_autofree(tile_map)
		return tile_map
	
	func test_nominal():
		var map := create_test_map()
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO, parent)
		#Act
		parent.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_parent_scale():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent)
		#Act
		parent.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), (cell + map.tile_map.cell_size/2) * 3)

	func test_with_parent_movement_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_parent_scale_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), (cell + map.tile_map.cell_size/2) * 3)

	func test_with_offset():
		#setup and act
		var map := create_test_map(Vector2.ONE * 2)
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_cell_size():
		#setup
		var map := create_test_map()
		#act
		map.tile_map.cell_size += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.map_to_global(cell,map), cell * 3 + map.tile_map.cell_size/2)

class Test_local_to_map:
	extends "res://addons/gut/test.gd"
		
	func create_test_map(offset : Vector2 = Vector2.ZERO, parent : Node2D = null, parent_squared : Node2D = null)-> Map:
		var map = Map.new(parent_autofreed_tilemap(parent,parent_squared))
		map.tile_map.cell_size = Vector2.ONE
		for x in MAP_SIZE:
			for y in MAP_SIZE:
				map.tile_map.set_cell(x + offset.x,y + offset.y,0)
		return map

	func parent_autofreed_tilemap(parent : Node2D, parent_squared : Node2D)-> TileMap:
		var tile_map = TileMap.new()
		if parent_squared:
			add_child_autofree(parent_squared)
			parent_squared.add_child(parent)
			parent.add_child(tile_map)
		elif parent:
			add_child_autofree(parent)
			parent.add_child(tile_map)
		else:
			add_child_autofree(tile_map)
		return tile_map
	
	func test_nominal():
		var map := create_test_map()
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO, parent)
		#Act
		parent.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent)
		#Act
		parent.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_offset():
		#setup and act
		var map := create_test_map(Vector2.ONE * 2)
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_cell_size():
		#setup
		var map := create_test_map()
		#act
		map.tile_map.cell_size += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.local_to_map(cell,map), cell * 3 + map.tile_map.cell_size/2)

class Test_global_to_map:
	extends "res://addons/gut/test.gd"
		
	func create_test_map(offset : Vector2 = Vector2.ZERO, parent : Node2D = null, parent_squared : Node2D = null)-> Map:
		var map = Map.new(parent_autofreed_tilemap(parent,parent_squared))
		map.tile_map.cell_size = Vector2.ONE
		for x in MAP_SIZE:
			for y in MAP_SIZE:
				map.tile_map.set_cell(x + offset.x,y + offset.y,0)
		return map

	func parent_autofreed_tilemap(parent : Node2D, parent_squared : Node2D)-> TileMap:
		var tile_map = TileMap.new()
		if parent_squared:
			add_child_autofree(parent_squared)
			parent_squared.add_child(parent)
			parent.add_child(tile_map)
		elif parent:
			add_child_autofree(parent)
			parent.add_child(tile_map)
		else:
			add_child_autofree(tile_map)
		return tile_map
	
	func test_nominal():
		var map := create_test_map()
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO, parent)
		#Act
		parent.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent)
		#Act
		parent.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_movement_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_parent_scale_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2)

	func test_with_offset():
		#setup and act
		var map := create_test_map(Vector2.ONE * 2)
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell + map.tile_map.cell_size/2 + Vector2.ONE * 2)

	func test_with_cell_size():
		#setup
		var map := create_test_map()
		#act
		map.tile_map.cell_size += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			assert_eq(MapSpaceConverter.global_to_map(cell,map), cell * 3 + map.tile_map.cell_size/2)
