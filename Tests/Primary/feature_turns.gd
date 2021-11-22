extends "res://addons/gut/test.gd"

func test_single_attack():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("attack",0)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_eneimes_ignored(params = use_parameters([true,false])):
	#Arrange
	var turn_manager = TurnManager.new()
	turn_manager.evil_turn = params
	var person = Person.new(Character.new(),params)
	turn_manager._on_map_person_added(person)
	turn_manager._on_map_person_added(Person.new(Character.new(),!params))
	watch_signals(turn_manager)
	#Act
	person.emit_signal("end_turn",0)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")
	
func test_turn_sequence(params = use_parameters([true,false])):
	#Arrange
	var turn_manager = TurnManager.new()
	turn_manager.evil_turn = params
	var person = Person.new(Character.new(),params)
	var other = Person.new(Character.new(),!params)
	turn_manager._on_map_person_added(person)
	turn_manager._on_map_person_added(other)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("end_turn")
	other.emit_signal("end_turn")
	#Assert
	assert_signal_emit_count(turn_manager,"turn_ended",2)

func test_doubles_turn_sequence(params = use_parameters([true,false])):
	#Arrange
	var turn_manager = TurnManager.new()
	turn_manager.evil_turn = params

	var person0 = Person.new(Character.new(),params)
	var person1 = Person.new(Character.new(),params)
	var other0 = Person.new(Character.new(),!params)
	var other1 = Person.new(Character.new(),!params)

	turn_manager._on_map_person_added(person0)
	turn_manager._on_map_person_added(person1)
	turn_manager._on_map_person_added(other0)
	turn_manager._on_map_person_added(other1)

	watch_signals(turn_manager)

	#Act
	person0.emit_signal("end_turn")
	person1.emit_signal("end_turn")
	other0.emit_signal("end_turn")
	#Assert
	assert_signal_emit_count(turn_manager,"turn_ended",1)
	#Act
	other1.emit_signal("end_turn")
	#Assert
	assert_signal_emit_count(turn_manager,"turn_ended",2)

func test_single_move():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("move",Vector2.ZERO)
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_single_close():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("close_window")
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")

func test_single_skip():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("end_turn")
	#Assert
	assert_signal_emitted(turn_manager,"turn_ended")

func test_double_attack():
	#Arrange
	var turn_manager = TurnManager.new()
	var person = Person.new(Character.new())
	turn_manager._on_map_person_added(Person.new(Character.new()))
	turn_manager._on_map_person_added(person)
	watch_signals(turn_manager)
	#Act
	person.emit_signal("end_turn")
	#Assert
	assert_signal_not_emitted(turn_manager,"turn_ended")
