extends Node

var SONG:Chart
var METADATA:Metadata
var variation:String = "default"
var instrumental:String = "default"

const note_directions:Array[String] = [
	"left", "down", "up", "right",
]
var default_ui_skin:String = "funkin"

const audio_formats:PackedStringArray = [".ogg", ".mp3", ".wav"]

var scene_arguments:Dictionary = {
	"options_menu": {
		"exit_scene_path": ""
	}
}

var game_size:Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)

var death_camera_zoom:Vector2 = Vector2.ONE
var death_camera_pos:Vector2 = Vector2.ZERO
var death_char_pos:Vector2 = Vector2(700, 360)
var death_character:String = "bf-dead"

var health_gain_mult:float = 1.0
var health_loss_mult:float = 1.0

var death_sound:AudioStream = preload("res://assets/sounds/death/fnf_loss_sfx.ogg")
var death_music:AudioStream = preload("res://assets/music/gameOver.ogg")
var retry_sound:AudioStream = preload("res://assets/music/gameOverEnd.ogg")

var current_difficulty:String = "hard"

var is_story_mode:bool = false
var current_week:int = 0
var queued_songs:PackedStringArray = []

var game_version = ProjectSettings.get_setting("application/config/version") #+ "\n"
var new_version: String

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	last_scene_path = get_tree().current_scene.scene_file_path
	ModManager.switch_mod(SettingsAPI.get_setting("current mod"))
	RenderingServer.set_default_clear_color(Color.BLACK)
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_vsync(value:bool):
	if value:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _notification(what):
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			if SettingsAPI.get_setting("auto pause"):
				set_vsync(SettingsAPI.get_setting('vsync'))
				Engine.max_fps = 10
				Audio.process_mode = Node.PROCESS_MODE_DISABLED
				Transition.process_mode = Node.PROCESS_MODE_DISABLED
				AudioServer.set_bus_volume_db(0,-INF)
				get_tree().paused = true

		NOTIFICATION_APPLICATION_FOCUS_IN:
			if SettingsAPI.get_setting("auto pause"):
				set_vsync(SettingsAPI.get_setting('vsync'))
				Engine.max_fps = SettingsAPI.get_setting("fps")
				Audio.process_mode = Node.PROCESS_MODE_ALWAYS
				Transition.process_mode = Node.PROCESS_MODE_ALWAYS
				VolumeSlider.update_volume()
				get_tree().paused = false

var transitioning:bool = false
var last_scene_path:String

func switch_scene(path:String) -> void:
	last_scene_path = path
	transitioning = true
	get_tree().paused = true

	var anim_player:AnimationPlayer = Transition.anim_player
	anim_player.play("in")

	await get_tree().create_timer(anim_player.get_animation("in").length).timeout

	get_tree().change_scene_to_file(path)

	await get_tree().create_timer(0.05).timeout

	anim_player.play("out")

	await get_tree().create_timer(anim_player.get_animation("out").length).timeout

	transitioning = false
	get_tree().paused = false

func reset_scene(from_mod_menu:bool = false) -> void:
	transitioning = true
	get_tree().paused = true

	var anim_player:AnimationPlayer = Transition.anim_player
	anim_player.play("in")

	await get_tree().create_timer(anim_player.get_animation("in").length).timeout

	if from_mod_menu:
		get_tree().change_scene_to_file("res://scenes/ReloadHelper.tscn")
	else:
		get_tree().change_scene_to_file(last_scene_path)

	await get_tree().create_timer(0.05).timeout

	anim_player.play("out")

	await get_tree().create_timer(anim_player.get_animation("out").length).timeout

	transitioning = false
	get_tree().paused = false

func _input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		var window:Window = get_window()
		if window.mode == Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_WINDOWED
		else:
			window.mode = Window.MODE_FULLSCREEN

func list_files_in_dir(path:String):
	var files:PackedStringArray = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()

		while true:
			var file = dir.get_next()
			if file == "": break
			elif not file.begins_with("."):
				files.append(file)

		dir.list_dir_end()

	return files

func add_zeros(str:String, num:int) -> String:
	return str.pad_zeros(num)

func bytes_to_human(size:float) -> String:
	var labels:PackedStringArray = ["b", "kb", "mb", "gb", "tb"]
	var r_size:float = size
	var label:int = 0

	while r_size > 1024 and label < labels.size() - 1:
		label += 1
		r_size /= 1024

	return str(r_size).pad_decimals(2) + labels[label]

func float_to_minute(value:float) -> int:
	return int(value / 60)

func float_to_seconds(value:float) -> float:
	return fmod(value, 60)

func format_time(value:float) -> String:
	if value < 0.0: value = 0.0
	return "%02d:%02d" % [float_to_minute(value), float_to_seconds(value)]

var trans_types = {
		"linear": Tween.TRANS_LINEAR,
		"sine": Tween.TRANS_SINE,
		"quint": Tween.TRANS_QUINT,
		"quart": Tween.TRANS_QUART,
		"quad": Tween.TRANS_QUAD,
		"expo": Tween.TRANS_EXPO,
		"elastic": Tween.TRANS_ELASTIC,
		"cubic": Tween.TRANS_CUBIC,
		"circ": Tween.TRANS_CIRC,
		"bounce": Tween.TRANS_BOUNCE,
		"back": Tween.TRANS_BACK,
		"spring": Tween.TRANS_SPRING
	}

var ease_types = {
		"inout": Tween.EASE_IN_OUT,
		"outin": Tween.EASE_OUT_IN,
		"in": Tween.EASE_IN,
		"out": Tween.EASE_OUT
	}

var gameplay_values: Dictionary = {
	"nothing": "",
	"score": 0,
	"misses": 0,
	"accuracy": 0.00,
	"accuracy rank": "N/A",
	"rank": "N/A",
	"health": 50,
	"combo": 0,
	"max combo": 0,
	"ghost presses": 0,
	"key presses": 0,
	"current time": format_time(0),
	"max time": format_time(0),
	"time left": format_time(0),
	"song name": "Bopeebo",
	"difficulty": "Hard",
	"sick hits": 0,
	"good hits": 0,
	"bad hits": 0,
	"shit hits": 0,
}

func reset_gameplay_values():
	gameplay_values["score"] =			0
	gameplay_values["misses"] =			0
	gameplay_values["accuracy"] =		0.00
	gameplay_values["accuracy rank"] =	"N/A"
	gameplay_values["rank"] =			"N/A"
	gameplay_values["health"] =			50
	gameplay_values["combo"] =			0
	gameplay_values["max combo"] =		0
	gameplay_values["ghost presses"] =	0
	gameplay_values["key presses"] =	0
	gameplay_values["current time"] =	format_time(0)
	gameplay_values["max time"] =		format_time(0)
	gameplay_values["time left"] =		format_time(0)
	gameplay_values["song name"] =		"Bopeebo"
	gameplay_values["difficulty"] =		"Hard"
	gameplay_values["sick hits"] =		0
	gameplay_values["good hits"] =		0
	gameplay_values["bad hits"] =		0
	gameplay_values["shit hits"] =		0

func parse_ease(ease_string: String) -> Dictionary:
	var ease_type = Tween.EASE_IN_OUT  # default
	var trans_type_str = "linear"  # fallback
	ease_string = ease_string.to_lower()

	for suffix in ease_types.keys():
		if ease_string.ends_with(suffix):
			ease_type = ease_types[suffix]
			trans_type_str = ease_string.left(ease_string.length() - suffix.length())
			break

	var trans_type = trans_types.get(trans_type_str, Tween.TRANS_LINEAR)

	return {
		"trans_type": trans_type,
		"ease_type": ease_type
	}
