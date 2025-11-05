extends Node

var _options:Dictionary = {
	# Controls
	# Controls/Notes
	"note_left":			["A", "LEFT"],
	"note_down":			["S", "DOWN"],
	"note_up":				["W", "UP"],
	"note_right":			["D", "RIGHT"],

	# Controls/UI
	"funkin_left":			["A", "LEFT"],
	"funkin_down":			["S", "DOWN"],
	"funkin_up":			["W", "UP"],
	"funkin_right":			["D", "RIGHT"],

	# Controls/Menus
	"funkin_accept":		["ENTER", "SPACE"],
	"funkin_cancel":		["BACKSPACE", "ESCAPE"],
	"funkin_pause":			["ENTER", "UNKNOWN"],
	"switch_mod":			["TAB", "SHIFT"],

	# Controls/Volume
	"volume_up":			["PLUS", "KP ADD"],
	"volume_down":			["MINUS", "KP SUBTRACT"],
	"volume_mute":			["0", "KP 0"],

	# Gameplay
	"downscroll":			false,
	"middlescroll":			false,
	"ghost tap":			false,

	# Appearance
	"flashing lights":		true,
	"note splashes":		true,

	# Appearance/Strumline
	"oppStrumVis":			1.0,
	"oppStrumScale":		1.0,
	"playerStrumVis":		1.0,
	"playerStrumScale":		1.0,

	# Appearance/Camera
	"cam movement":			true,
	"cam zooms":			true,
	"cam shakes":			true,

	# Appearance/HUD options
	"hud zooms":			true,
	"hud shakes":			true,

	# Audio
	"miss sound volume":	1.0,
	"hit sound volume":		0.0,
	"volume":				1.0,
	"muted":				false,

	# Window
	"auto pause":			false,
	"vsync":				false,
	"fps":					60,

	# Engine
	"fps counter":			false,
	"current mod":			"Friday Night Funkin'",
	"last hud file":		"res://assets/defaultHud.json",
	"first launch":			true,
}

const JSON_PATH:String = "user://options.json"

func _ready() -> void:
	var json:Dictionary

	if not ResourceLoader.exists(JSON_PATH):
		var file = FileAccess.open(JSON_PATH, FileAccess.WRITE)
		file.store_string("{}")
	else:
		var file = FileAccess.open(JSON_PATH, FileAccess.READ)
		if file.get_as_text() == null or len(file.get_as_text()) < 1:
			json = {}
		else:
			json = JSON.parse_string(file.get_as_text())

	for key in _options:
		if not key in json:
			json[key] = _options[key]
			print(key+" not present, creating!")
		else:
			_options[key] = json[key]
			print(key+" initialized successfully!")

	var f = FileAccess.open(JSON_PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(json, "\t"))

	setup_binds()

	print("Initialized options!")

func setup_binds():
	Input.set_use_accumulated_input(false)

	var binds:PackedStringArray = [
		"note_left", "note_down", "note_up", "note_right",
		"funkin_left", "funkin_down", "funkin_up", "funkin_right",
		"funkin_accept", "funkin_cancel", "funkin_pause", "switch_mod",
		"volume_up", "volume_down", "volume_mute"
	]

	for bind in binds:
		var keys = InputMap.action_get_events(bind)

		# normal bind
		var event1 = InputEventKey.new()
		event1.set_keycode(OS.find_keycode_from_string(_options[bind][0].to_lower()))

		# alt bind
		var event2= InputEventKey.new()
		event2.set_keycode(OS.find_keycode_from_string(_options[bind][1].to_lower()))

		if keys.size() -1 != -1: # error handling
			for i in keys:
				InputMap.action_erase_event(bind, i)
		else:
			InputMap.add_action(bind)

		InputMap.action_add_event(bind, event1)
		InputMap.action_add_event(bind, event2)

func update_settings() -> void:
	for key in _options.keys():
		match key:
			"vsync":
				Global.set_vsync(_options[key])
			"fps":
				Engine.max_fps = _options[key]

func get_option(option:String):
	if option in _options:
		return _options[option]

	return null

func set_option(option:String, value:Variant):
	_options[option] = value

func flush():
	var file := FileAccess.open(JSON_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(_options, "\t"))
