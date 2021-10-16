extends "res://addons/gut/test.gd"
class_name ConversionTests
const MAP_SIZE := 5

class ConversionTest:
	extends "res://addons/gut/test.gd"

	var grid_size := Vector2.ONE
	var use_half_offset := true
	var use_parent_transforms := false

	func tested_function(_cell : Vector2,_map : Map) -> Vector2:
		return Vector2.ZERO

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
			var expected = cell 
			if (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_parent_movement():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO, parent)
		#Act
		parent.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell
			if use_parent_transforms:
				expected += Vector2.ONE * 2
			if (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_parent_scale():
		#setup
		var parent = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent)
		#Act
		parent.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell
			if use_parent_transforms:
				expected *= 3
				if use_half_offset:
					expected += map.tile_map.cell_size*3/2
			elif (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_parent_movement_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.position += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell
			if use_parent_transforms:
				expected += Vector2.ONE * 2
			if (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_parent_scale_squared():
		#setup
		var parent = Node2D.new()
		var parent_squared = Node2D.new()
		var map := create_test_map(Vector2.ZERO,parent,parent_squared)
		#Act
		parent_squared.scale += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell
			if use_parent_transforms:
				expected *= 3
				if use_half_offset:
					expected += map.tile_map.cell_size*3/2
			elif (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_offset():
		#setup and act
		var map := create_test_map(Vector2.ONE * 2)
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell + Vector2.ONE * 2
			if (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

	func test_with_cell_size():
		#setup
		var map := create_test_map()
		#act
		map.tile_map.cell_size += Vector2.ONE * 2
		#Assert
		for cell in map.tile_map.get_used_cells():
			var expected = cell * 3
			if (use_half_offset):
				expected += map.tile_map.cell_size/2
			cell *= grid_size
			assert_eq(tested_function(cell,map), expected)

class Test_map_to_local:
	extends ConversionTest

	func tested_function(cell : Vector2,map : Map) -> Vector2:
		return MapSpaceConverter.map_to_local(cell,map)

class Test_map_to_global:
	extends ConversionTest

	func before_all():
		use_parent_transforms = true
	
	func tested_function(cell : Vector2,map : Map) -> Vector2:
		return MapSpaceConverter.map_to_global(cell,map)
	
class Test_local_to_map:
	extends ConversionTest

	func before_all():
		use_half_offset = false

	func tested_function(cell : Vector2,map : Map) -> Vector2:
		return MapSpaceConverter.local_to_map(cell,map)
			
class Test_global_to_map:
	extends ConversionTest

	func before_all():
		use_half_offset = false

	func tested_function(cell : Vector2,map : Map) -> Vector2:
		return MapSpaceConverter.global_to_map(cell,map)