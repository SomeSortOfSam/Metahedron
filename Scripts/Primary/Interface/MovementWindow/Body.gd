extends Control
class_name MovementWindowBody

enum Mode {MOVEMENT,COMBAT,LOCKED}

onready var cursor : WindowCursor = $WindowCursor
onready var movement_cursor : ArrowLines = $WindowCursor/TilemapContainer/ArrowLines
onready var combat_cursor : AttackRenderer = $WindowCursor/TilemapContainer/AttackRenderer

onready var container : MapScaler = $WindowCursor/TilemapContainer

var mode = Mode.MOVEMENT setget set_mode
var movement_enabled := true
var combat_enabled := true
onready var map : ReferenceMap

signal accepted_new_tile(delta)
signal accepted_attack_direction(direction)

func set_mode(new_mode):
	mode = new_mode
	movement_cursor.hide()
	combat_cursor.hide()
	if new_mode == Mode.MOVEMENT:
		cursor.display = movement_cursor
		set_movement_enabled(movement_enabled)
	if new_mode == Mode.COMBAT:
		cursor.display = combat_cursor
		set_combat_enabled(combat_enabled)

func set_movement_enabled(new_movement_enabled : bool):
	movement_enabled = new_movement_enabled
	if new_movement_enabled && mode == Mode.MOVEMENT:
		movement_cursor.show()
	else:
		movement_cursor.hide()

func set_combat_enabled(new_combat_enabled : bool):
	combat_enabled = new_combat_enabled
	if new_combat_enabled && mode == Mode.COMBAT:
		combat_cursor.show()
		combat_cursor.set_center_cell(map)
	else:
		combat_cursor.hide()

func subscribe_map(map : Map):
	cursor.map = map
	var _connection = map.connect("position_changed", container, "correct_transform")

func subscribe_person(person):
	var _connection = connect("accepted_new_tile", self, "_on_accepted_new_tile",[person])
	_connection = person.connect("new_turn", self, "set_movement_enabled", [true])
	_connection = person.connect("new_turn", self, "set_combat_enabled", [true])

func populate_map(parent_map, cell, window_range):
	var new_map = ReferenceMap.new($WindowCursor/TilemapContainer/TileMap,parent_map,cell,window_range)
	new_map.outer_tile_map = $WindowCursor/TilemapContainer/OuterMap
	return new_map

func get_global_center() -> Vector2:
	return container.global_position

func lock():
	set_mode(Mode.LOCKED)

func _on_WindowCursor_position_accepted(cell: Vector2):
	if mode == Mode.MOVEMENT:
		emit_signal("accepted_new_tile",cell)
	if mode == Mode.COMBAT:
		emit_signal("accepted_attack_direction",cell)
	if mode == Mode.LOCKED:
		assert(false,"Cursor accepted " +str(cell) + " on locked window")

func _on_accepted_new_tile(delta : Vector2, person):
	if !person.has_moved:
		person.cell += delta
	set_movement_enabled(false)

func _on_accepted_attack_direction(direction : Vector2, person):
	set_combat_enabled(false)

func _on_CombatMenu_attack_selected(attack : Attack):
	combat_cursor.attack = attack
	set_mode(Mode.COMBAT)

func _on_Attack_back():
	set_mode(Mode.MOVEMENT)
