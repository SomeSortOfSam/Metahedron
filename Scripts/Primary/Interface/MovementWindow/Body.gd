extends Control

enum Mode {MOVEMENT,COMBAT,DISABLED}

onready var cursor : WindowCursor = $WindowCursor
onready var movement_cursor : ArrowLines = $WindowCursor/TilemapContainer/ArrowLines
onready var combat_cursor : AttackRenderer = $WindowCursor/TilemapContainer/AttackRenderer

var mode = Mode.MOVEMENT

func _on_CombatMenu_attack_selected(attack : Attack):
	combat_cursor.attack = attack
	cursor.display = combat_cursor
	movement_cursor.hide()
	combat_cursor.show()

func _on_Attack_back():
	cursor.display = movement_cursor
	combat_cursor.hide()
	movement_cursor.show()
	
