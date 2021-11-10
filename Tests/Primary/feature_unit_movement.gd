extends "res://addons/gut/test.gd"

var map : Map
var person0 : Person
var person1 : Person
var personE : Person
var map0 : ReferenceMap
var map1 : ReferenceMap
var mapE : ReferenceMap

func before_all():
	map = Map.new(TileMap.new())
	add_child(map.tile_map)
	for x in range(0,4):
		for y in range(0,4):
			map.tile_map.set_cell(x,y,0)
	map.astar = Pathfinder.map_to_astar(map)
	person0 = Person.new(Character.new())
	person1 = Person.new(Character.new(),false, Vector2(0,3))
	personE = Person.new(Character.new(),true, Vector2(3,0))
	map.add_person(person0)
	map.add_person(person1)
	map.add_person(personE)
	map.repopulate_displays()
	map0 = ReferenceMap.new(TileMap.new(),map,Vector2.ZERO,3)
	map1 = ReferenceMap.new(TileMap.new(),map,Vector2.RIGHT *3,3)
	mapE = ReferenceMap.new(TileMap.new(),map,Vector2.DOWN * 3,3)
	add_child(map0.tile_map)
	add_child(map1.tile_map)
	add_child(mapE.tile_map)
	var _connection = person0.connect("move",self,"_on_person_move",[person0])
	_connection = person1.connect("move",self,"_on_person_move",[person1])
	_connection = personE.connect("move",self,"_on_person_move",[personE])

func _on_person_move(delta : Vector2, person : Person):
	if person == person0:
		map0.center_cell += delta
	if person == person1:
		map1.center_cell += delta
	if person == personE:
		mapE.center_cell += delta

func before_each():
	person0.cell = Vector2.ZERO
	person1.cell = Vector2.RIGHT * 3
	personE.cell = Vector2.DOWN * 3

func after_all():
	map.tile_map.free()
	map0.tile_map.free()
	map1.tile_map.free()
	mapE.tile_map.free()

func test_map_unit_moves():
	#Act
	person0.cell += Vector2.ONE
	#Assert
	assert_not_null(map.tile_map.get_child(0)._followe.curve)

func test_refrence_map_unit_inter_moves():
	#Act
	person0.cell += Vector2.ONE
	#Assert
	var curve : Curve2D = map0.tile_map.get_child(0)._followe.curve
	assert_not_null(curve)
	if curve:
		assert_gt(curve.get_point_count(),1)

func test_refrence_map_unit_emigrate():
	#Act
	person1.cell += Vector2.DOWN * 3
	#Assert
	var unit : Unit = map0.tile_map.get_child(1)
	var curve : Curve2D = unit._followe.curve
	assert_not_null(curve)
	if curve:
		assert_gt(curve.get_point_count(),1)
	unit.end_follow_animation()
	assert_ne(unit,map0.tile_map.get_child(1))

func test_refrecne_map_unit_immigrate():
	pending()
