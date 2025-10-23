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

	# Bar Style Default (Background)
	"Bar BG Color": "999999",
	"Bar BG Border Color": "cccccc",
	"Bar BG Shadow Color": "00000099",

	"Bar BG Border Left": 4,
	"Bar BG Border Top": 4,
	"Bar BG Border Right": 4,
	"Bar BG Border Bottom": 4,

	"Bar BG Corner Radius TopLeft": 0,
	"Bar BG Corner Radius TopRight": 0,
	"Bar BG Corner Radius BottomLeft": 0,
	"Bar BG Corner Radius BottomRight": 0,

	"Bar BG Expand Left": 4,
	"Bar BG Expand Top": 4,
	"Bar BG Expand Right": 4,
	"Bar BG Expand Bottom": 4,

	"Bar BG Shadow Size": 0,
	"Bar BG Shadow Offset X": 0,
	"Bar BG Shadow Offset Y": 0,

	# Bar Style Default (Fill)
	"Bar Fill Color": "999999",
	"Bar Fill Border Color": "cccccc",
	"Bar Fill Shadow Color": "00000099",

	"Bar Fill Border Left": 0,
	"Bar Fill Border Top": 0,
	"Bar Fill Border Right": 0,
	"Bar Fill Border Bottom": 0,

	"Bar Fill Corner Radius TopLeft": 0,
	"Bar Fill Corner Radius TopRight": 0,
	"Bar Fill Corner Radius BottomLeft": 0,
	"Bar Fill Corner Radius BottomRight": 0,

	"Bar Fill Expand Left": 0,
	"Bar Fill Expand Top": 0,
	"Bar Fill Expand Right": 0,
	"Bar Fill Expand Bottom": 0,

	"Bar Fill Shadow Size": 0,
	"Bar Fill Shadow Offset X": 0,
	"Bar Fill Shadow Offset Y": 0,
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
