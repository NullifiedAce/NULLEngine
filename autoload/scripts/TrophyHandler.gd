extends Node

var trophies:Dictionary = {
	"BT": false, "BT_0": false,
	"B1": false, "B1_0": false,
	"B2": false, "B2_0": false,
	"B3": false, "B3_0": false,
	"B4": false, "B4_0": false,
	"B5": false, "B5_0": false,
	"B6": false, "B6_0": false,
	"B7": false, "B7_0": false,
	"BW1": false, "BW1_0": false,
}

var cfg_file = ConfigFile.new()

func _ready() -> void:
	if !FileAccess.file_exists("user://trophies.cfg"):
		setup_cfg()

	load_cfg()

func setup_cfg():
	for i in trophies:
		cfg_file.set_value("Trophy", i, trophies[i])
		cfg_file.save("user://trophies.cfg")

func load_cfg():
	var err = cfg_file.load("user://trophies.cfg")

	if err != OK:
		return

	for i in trophies:
		print("boo!")
		if cfg_file.has_section_key("Trophy", i):
			print("true")
			trophies[i] = cfg_file.get_value("Trophy", i)
		else:
			print("false")
			cfg_file.set_value("Trophy", i, trophies[i])
			cfg_file.save("user://trophies.cfg")

func save_trophy(trophy_name:String, value:bool):
	if trophies.has(trophy_name): # Make sure the trophy even exists in the dictionary
		cfg_file.set_value("Trophy", trophy_name, value)
		cfg_file.save("user://trophies.cfg")
