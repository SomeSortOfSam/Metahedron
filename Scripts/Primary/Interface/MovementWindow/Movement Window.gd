extends Control
class_name MovementWindow, "res://Assets/Editor Icons/MovementWindow.png"
## Application window what lets units move. Main element of the game.

onready var close_button : TextureButton = $TopBar/Close

onready var attack_button : TextureButton = $TopBar/Attack
onready var combat_menu : CombatMenu = $Body/CombatMenu

onready var body : MovementWindowBody = $Body/Body
onready var topbar = $TopBar
onready var icon : TextureRect = $TopBar/Body/Icon

onready var outline0 : ColorRect = $Body/Outline
onready var outline1 : ColorRect = $TopBar/Outline

var map : ReferenceMap setget set_map

var player_accessible := true

signal requesting_close()

func _ready():
	hide()
	resize()
	var _connection = get_tree().connect("screen_resized",self,"resize")

func resize():
	rect_size = get_small_window_size(get_viewport_rect())

func center_around_tile(tile : Vector2):
	rect_position = MapSpaceConverter.map_to_global(tile,map.map)
	rect_position -= -rect_global_position + body.get_global_center()
	topbar.correct_window_pos()

func set_map(new_map : ReferenceMap):
	map = new_map
	map.repopulate_displays()
	body.subscribe_map(map)

func subscribe(person):
	player_accessible = !person.is_evil
	icon.texture = person.character.level_texture
	
	body.subscribe_person(person)
	
	var _connection
	
	if (player_accessible):
		_connection = connect("requesting_close", person, "_on_window_requesting_close")
		_connection = person.connect("new_turn", self, "_on_person_new_turn")
		_connection = person.connect("attack", self, "_on_person_attack")
		combat_menu.subscribe(person)
	else:
		lock_window()
	
	_connection = person.connect("move", self, "_on_person_move")
	_connection = person.connect("close_window", self, "_on_person_close_window")
	_connection = person.connect("open_window", self, "_on_person_open_window")

static func get_small_window_size(veiwport_rect : Rect2) -> Vector2:
	var third = veiwport_rect.size/3
	if Settings.new().squareWindows:
		third.x = min(third.x,third.y)
		third.y = min(third.x,third.y)
	return third

static func get_window(cell : Vector2, parent_map, window_range : int) -> MovementWindow:
	var packed_window := load("res://Scripts/Primary/Interface/MovementWindow/Movement Window.tscn")
	var window : MovementWindow = packed_window.instance()
	window.body = window.get_node("Body/Body")
	window.call_deferred("set_map", window.body.populate_map(parent_map, cell, window_range))
	return window

func lock_window():
	close_button.set_disabled(true)
	close_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	attack_button.set_disabled(true)
	attack_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	topbar.lock()
	body.lock()

func _on_person_new_turn():
	close_button.set_disabled(false)
	attack_button.set_disabled(false)

func _on_person_move(delta : Vector2):
	map.center_cell += delta
	close_button.set_disabled(true)

func _on_person_attack(_direction,_attack):
	close_button.set_disabled(true)
	attack_button.set_disabled(true)

func _on_Close_pressed():
	emit_signal("requesting_close")

func _on_person_close_window():
	hide()

func _on_person_open_window():
	show()
	call_deferred("call_deferred","center_around_tile",map.center_cell) #1 frame to render, 1 frame for rect_size to update

func _on_TopBar_accepted_window_movement(delta):
	if (player_accessible):
		rect_position += delta

func _on_Window_focus_entered():
	if (player_accessible):
		outline0.color.v += .05
		outline1.color.v += .05

func _on_Window_focus_exited():
	if (player_accessible):
		outline0.color.v -= .05
		outline1.color.v -= .05

func _on_CombatMenu_attack_selected(_attack):
	_on_Window_focus_exited()

func _on_Body_map_populated(new_map : ReferenceMap):
	self.map = new_map
