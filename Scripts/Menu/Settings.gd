extends Reference
class_name Settings

export var volume := 1.0
export var fullMap := true
export var squareWindows := true

func _init():
	var configs := ConfigFile.new()
	if 0 == configs.load("user://Settings.cfg"):
		volume = configs.get_value("Settings","Volume")
		fullMap = configs.get_value("Settings","FullMap")
		squareWindows = configs.get_value("Settings","SquareWindows")

func save():
	var configs = ConfigFile.new()
	configs.set_value("Settings","Volume",volume)
	configs.set_value("Settings","FullMap",fullMap)
	configs.set_value("Settings","SquareWindows",squareWindows)
	configs.save("user://Settings.cfg") 
