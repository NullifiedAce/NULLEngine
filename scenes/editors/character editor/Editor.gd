extends MusicBeatScene
class_name CharacterEditor

var default_data:Dictionary = {
	"is_animated": true,
	"is_player": false,

	"can_sing": true,

	"sing_duration": 4.0,
	
	"dances": true,
	"dance_steps": ["idle"],

	"combo_anims": {},

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
	"anim_data": []
}

var character_data:CharacterData

@onready var character: EditorCharacter = $Character

@onready var file_popup: PopupMenu = $CanvasLayer/MenuBar/File
@onready var windows_popup: PopupMenu = $CanvasLayer/MenuBar/Windows

@onready var windows_group: Node = $Windows

@onready var load_character_dialog: FileDialog = $Windows/LoadCharacter

@onready var character_data_window: Window = $"Windows/Character Data"

func _ready() -> void:
	FPS.fps_label.modulate = Color.TRANSPARENT
	FPS.mem_label.modulate = Color.TRANSPARENT

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	RichPresence.set_text("In the editor", "Character Editor")

func _process(delta: float):
	if Input.is_action_just_pressed("funkin_accept"):
		character.dance(true)
	if Input.is_action_just_pressed("funkin_down"):
		character.play_anim("singDOWN", true)
		character.hold_timer = 0.0
	if Input.is_action_just_pressed("funkin_up"):
		character.play_anim("singUP", true)
		character.hold_timer = 0.0
	if Input.is_action_just_pressed("funkin_right"):
		character.play_anim("singRIGHT", true)
		character.hold_timer = 0.0
	if Input.is_action_just_pressed("funkin_left"):
		character.play_anim("singLEFT", true)
		character.hold_timer = 0.0

func _exit_tree() -> void:
	FPS.fps_label.modulate = Color.WHITE
	FPS.mem_label.modulate = Color.WHITE

func _on_file_id_pressed(id: int) -> void:
	var item = file_popup.get_item_text(id)

	match item:
		"Load character...":
			load_character_dialog.show()

func _on_windows_id_pressed(id: int) -> void:
	var window_name = windows_popup.get_item_text(id)

	for i in windows_group.get_children():
		if i.name == window_name:
			i.visible = not i.visible

func _load_character_file(path: String) -> void:
	character_data = CharacterData.load_from_json(JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text()))

	character._setup()

	character_data_window.load_data(character_data)
