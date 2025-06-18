extends MusicBeatScene

var current_track:String
var track_volume:float = 1.0
var track_paused:bool = false

var current_stage:String = "mainStage"
var stage:Stage

var character_data:Dictionary = {
	"asset_file": "",
	"antialiasing": true,

	"position": Vector2.ZERO,
	"scale": 1,
	"flip_x": false,

	"icon": "icon-face",
	"icon-color": "000000FF",

	"sing_duration": 4.0,

	"animations": [],
}

@onready var file: MenuButton = $Menu/TopBar/MenuButtons/File
@onready var edit: MenuButton = $Menu/TopBar/MenuButtons/Edit
@onready var windows: MenuButton = $Menu/TopBar/MenuButtons/Windows
@onready var about: MenuButton = $Menu/TopBar/MenuButtons/About

@onready var file_popup:PopupMenu = file.get_popup()
@onready var edit_popup:PopupMenu = edit.get_popup()
@onready var windows_popup:PopupMenu = windows.get_popup()
@onready var about_popup:PopupMenu = about.get_popup()

@onready var camera: EditorCamera = $Camera

@onready var music: AudioPlayer = $Music

@onready var gf: Character = $"Character Ghosts/gf"
@onready var dad: Character = $"Character Ghosts/dad"
@onready var bf: Character = $"Character Ghosts/bf"

@onready var track_window: Window = $"Windows/Background Track"

func _ready():
	super._ready()
	get_tree().paused = false

	windows_popup.id_pressed.connect(_window_menu)

	RichPresence.set_text("In the editors", "Character Editor")

	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 0.25)

	load_background_track("res://assets/music/chartEditorLoop.ogg")
	load_stage()

	bf._is_true_player = true
	bf.scale.x *= -1
	bf.anim_sprite.position.x += bf.initial_size.x * absf(bf.anim_sprite.scale.x)

func _exit_tree() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 1)

func _window_menu(id:int):
	match windows_popup.get_item_text(id):
		"Background Track":
			windows_popup.set_item_checked(id, not windows_popup.is_item_checked(id))
			track_window.visible = windows_popup.is_item_checked(id)

	camera.dragging = false

func _process(delta: float) -> void:
	Conductor.position = music.time
	music.volume_db = 80 * (track_volume - 1)

	if track_paused:
		music.stream_paused = true
	else:
		music.stream_paused = false

func beat_hit(beat:int) -> void:
	dad.dance()
	gf.dance()
	bf.dance()

func load_background_track(path:String):
	music.stream = load(path)
	music.stream.loop = true
	Conductor.bpm_change_map.clear()
	Conductor.change_bpm(music.stream.bpm)

	music.play()

func load_stage():
	if stage: remove_child(stage)

	var stage_path:String = "res://scenes/gameplay/stages/"+current_stage+".tscn"
	if ResourceLoader.exists(stage_path):
		stage = load(stage_path).instantiate()
	else:
		stage = load("res://scenes/gameplay/stages/mainStage.tscn").instantiate()

	add_child(stage)

	camera.default_cam_zoom = stage.default_cam_zoom
	camera.zoom = Vector2(camera.default_cam_zoom, camera.default_cam_zoom)

	dad.global_position = stage.character_positions["opponent"].global_position
	dad.z_index = stage.character_positions["opponent"].z_index
	gf.global_position = stage.character_positions["spectator"].global_position
	gf.z_index = stage.character_positions["spectator"].z_index
	bf.global_position = stage.character_positions["player"].global_position
	bf.z_index = stage.character_positions["player"].z_index
