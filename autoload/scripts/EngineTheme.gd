extends Node

var cfg_file:ConfigFile = ConfigFile.new()
var path = SaveData.path + "EngineTheme.cfg"

var theme_data:Dictionary = {
	# HUD Editor Background
	"HUD BG Color": "ffffff",
	"HUD BG Gradiant1": "ffffff69",
	"HUD BG Gradiant2": "ffffff00",

	# Label Style Default
	"Label Font": 0,
	"Label Font Color": "ffffff",
	"Label Font Size": 16,

	"Label Outline Color": "000000",
	"Label Outline Size": 8,

	"Label Shadow Color": "00000000",
	"Label Shadow Size": 0,
	"Label Shadow Offset X": 0,
	"Label Shadow Offset Y": 0,
}

func _ready() -> void:
	if !FileAccess.file_exists(path):
		setup_cfg()

	load_data()

func setup_cfg():
	for i in theme_data:
		cfg_file.set_value("Theme", i, theme_data[i])
		cfg_file.save(path)

func load_data():
	var err = cfg_file.load(path)

	if err != OK:
		return

	for i in theme_data:
		if cfg_file.has_section_key("Theme", i):
			theme_data[i] = cfg_file.get_value("Theme", i)
		else:
			print("Data \"%s\" does not exist in data file, creating data now." % i)
			cfg_file.set_value("Theme", i, theme_data[i])
			cfg_file.save(path)

func save_theme_data(data:String, value:Variant):
	if theme_data.has(data):
		theme_data[data] = value
		cfg_file.set_value("Theme", data, value)
		cfg_file.save(path)

func get_theme_data(data:String):
	if theme_data.has(data):
		return theme_data[data]
	else:
		print("Data \"%s\" does not exist, have you wrote the data string correctly?" % data)
