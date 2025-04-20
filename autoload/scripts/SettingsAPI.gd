extends Node

const _json_path:String = "user://funkin_settings.json"
var _settings:Dictionary = {
	# gameplay
	"downscroll": false,
	"centered notefield": false,
	"ghost tapping": false,
	"miss sounds": true,
	"show ms on note hit": false,
	"skip intro by default": false,

	"note offset": 0.0,
	"scroll speed": 0.0,
	"scroll speed type": "Multiplier",

	# appearance
	"fps counter": true,
	"note splashes": true,
	"opaque sustains": false,
	"subtitles": true,
	"story always yellow": false,
	"judgement camera": "World",
	"judgement stacking": true,
	"hide score": false,
	"freeplay icon bumping": true,
	"flashing lights": true,

	# hud
	"engine theme": "Purple",
	"color style": "NULL",

	# hud editor
	"bg color": "ffffff",

	# health bar
	"icon colors": false,
	"custom color": false,
	"hide hpbar": false,
	"hide icons": false,
	"player color": "00ff00",
	"opp color": "ff0000",

	"hpbar x": 340,
	"hpbar y": 636,

	#score text
	"seperator": " - ",

	"score_arrangement": "[\"score\", \"misses\", \"accuracy\", \"ranks\"]",

	"font path": "res://assets/fonts/vcr.ttf",
	"font size": 19,
	"font color": "ffffff",

	"outline size": 10,
	"outline color": "000000",

	"score bg color": "0000009b",
	"score bg expand": 2,

	# score
	"score prefix": "Score: ",
	"score suffix": "",

	# misses
	"misses prefix": "Misses: ",
	"misses suffix": "",

	# accuracy
	"accuracy prefix": "Accuracy: ",
	"accuracy suffix": "%",

	# ranks
	"ranks prefix": "[",
	"ranks suffix": "]",
	"s+ rank": "S+",
	"s rank": "S",
	"a rank": "A",
	"b rank": "B",
	"c rank": "C",
	"d rank": "D",
	"e rank": "E",
	"f rank": "F",
	"null rank": "N/A",

	# health
	"health prefix": "",
	"health suffix": "%",

	# combo
	"combo prefix": "Combo: ",
	"combo suffix": "x",

	# max combo
	"max combo prefix": "(",
	"max combo suffix": ")",

	# ghost taps
	"ghost taps prefix": "Ghost Taps: ",
	"ghost taps suffix": "",

	# misc
	"auto pause": true,
	"volume beep pitching": false,
	"vsync": false,
	"multi threaded rendering": false,
	"fps": 240,
	"first launch": true,

	# controls (gameplay)
	"note_left": ["A", "LEFT"],
	"note_down": ["S", "DOWN"],
	"note_up": ["W", "UP"],
	"note_right": ["D", "RIGHT"],

	# controls (ui)
	"ui_left": ["A", "LEFT"],
	"ui_down": ["S", "DOWN"],
	"ui_up": ["W", "UP"],
	"ui_right": ["D", "RIGHT"],

	"ui_accept": ["ENTER", "SPACE"],
	"ui_cancel": ["BACKSPACE", "ESCAPE"],
	"ui_pause": ["ENTER", "UNKNOWN"],
	"switch_mod": ["TAB", "SHIFT"],

	"volume_up": ["EQUAL", "KP ADD"],
	"volume_down": ["MINUS", "KP SUBTRACT"],
	"volume_mute": ["0", "INSERT"],

	# engine
	"current mod": "Friday Night Funkin'",
	"volume": 0.5,
	"muted": false,
}

func setup_binds():
	Input.set_use_accumulated_input(false)

	var binds:PackedStringArray = [
		"note_left", "note_down", "note_up", "note_right",
		"ui_pause", "switch_mod",
		"volume_down", "volume_up", "volume_mute"
	]
	for bind in binds:
		var keys = InputMap.action_get_events(bind)

		# normal bind
		var event1 = InputEventKey.new()
		event1.set_keycode(OS.find_keycode_from_string(_settings[bind][0].to_lower()))

		# alt bind
		var event2 = InputEventKey.new()
		event2.set_keycode(OS.find_keycode_from_string(_settings[bind][1].to_lower()))

		if keys.size() - 1 != -1: # error handling shit
			for i in keys:
				InputMap.action_erase_event(bind, i)
		else:
			InputMap.add_action(bind)

		InputMap.action_add_event(bind, event1)
		InputMap.action_add_event(bind, event2)

func _ready():
	var json:Dictionary = {}

	if not ResourceLoader.exists(_json_path):
		var f = FileAccess.open(_json_path, FileAccess.WRITE)
		f.store_string("{}")
	else:
		var f = FileAccess.open(_json_path, FileAccess.READ)
		if f.get_as_text() == null or len(f.get_as_text()) < 1:
			json = {}
		else:
			json = JSON.parse_string(f.get_as_text())

	for key in _settings:
		if not key in json:
			json[key] = _settings[key]
			print(key+" not present, creating it!")
		else:
			_settings[key] = json[key]
			print(key+" initialized successfully!")

	var f = FileAccess.open(_json_path, FileAccess.WRITE)
	f.store_string(JSON.stringify(json))

	setup_binds()
	update_settings()
	Ranking.create_default_ranks()

	print("Initialized settings!")

func update_settings() -> void:
	for key in _settings.keys():
		match key:
			"vsync":
				Global.set_vsync(_settings[key])
			"multi threaded rendering":
				ProjectSettings.set_setting("rendering/driver/threads/thread_model", "Multi-Threaded" if _settings[key] else "Single-Safe")
			"fps":
				Engine.max_fps = _settings[key]

func get_setting(name:String):
	if name in _settings:
		return _settings[name]

	return null

func set_setting(name:String, value:Variant):
	_settings[name] = value

func flush():
	var file := FileAccess.open(_json_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(_settings))
