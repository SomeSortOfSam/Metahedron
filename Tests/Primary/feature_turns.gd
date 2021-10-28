extends "res://addons/gut/test.gd"

# Turn behavior
#
# Attacking always ends a units turn
# Moveing never ends a units turn
# Closeing a window ends a units turn, but can be reversed if other units have not ended their turn
# Skiping a turn ends a units turn, but can be reversed if other units have not ended their turn

func test_single_attack():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_attacked")
	#Assert
	assert_signal_emitted(turn_manager,"turn_ended")

func test_single_move():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("cell_change",Vector2.ZERO)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_single_close():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_set_end_turn",true)
	#Assert
	assert_signal_emitted(turn_manager,"turn_ended")

func test_single_skip():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_set_end_turn",true)
	#Assert
	assert_signal_emitted(turn_manager,"turn_ended")

func test_reversed_close():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(Person.new(Character.new()))
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_set_end_turn",true)
	person.emit_signal("has_set_end_turn",false)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_reversed_skip():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(Person.new(Character.new()))
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_set_end_turn",true)
	person.emit_signal("has_set_end_turn",false)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_double_attack():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(Person.new(Character.new()))
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("has_attacked")
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")
