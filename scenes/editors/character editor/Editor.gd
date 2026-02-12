extends MusicBeatScene

var character_data:Dictionary = {
	"is_animated": true,
	"is_player": false,

	"can_sing": true,

	"sing_duration": 4.0,
	
	"dances": true,
	"dance_steps": ["idle"],

	"combo_anims": [],

	"health_icon": "",
	"health_icon_scale": 1.0,
	"health_icon_filter": 0,
	"health_icon_frames": 2,
	"health_color": "FFFFFF",

	"death_character": "bf-dead",
	"death_sound": "res://assets/sounds/death/fnf_loss_sfx.ogg",
	"death_music": "res://assets/music/gameOver.ogg",
	"retry_sound": "res://assets/music/gameOverEnd.ogg",

	"voices_path": "dad",
	"character_script_path": "",
	"character_script_name": "",

	"sprite_frames": [],
	"anim_data": [],
}

var default_data:Dictionary

func _ready() -> void:
	FPS.fps_label.modulate = Color.TRANSPARENT
	FPS.mem_label.modulate = Color.TRANSPARENT

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	default_data = character_data

func _exit_tree() -> void:
	FPS.fps_label.modulate = Color.WHITE
	FPS.mem_label.modulate = Color.WHITE
