extends MusicBeatScene
class_name HUDEditor

var use_donwscroll:bool = false
var dragging:bool = false

var hovered_object:CanvasItem = null

var current_track:String
var track_volume:float = 1.0
var track_paused:bool = false

@onready var file_menu: MenuButton = $CanvasLayer/MenuOptions/File
@onready var edit_menu: MenuButton = $CanvasLayer/MenuOptions/Edit
@onready var options_menu: MenuButton = $CanvasLayer/MenuOptions/Options
@onready var windows_menu: MenuButton = $CanvasLayer/MenuOptions/Windows
@onready var help_menu: MenuButton = $CanvasLayer/MenuOptions/Help

@onready var preferences_window: Window = $Windows/Preferences
@onready var add_popup: PopupMenu = $AddPopup
@onready var add_element: PopupMenu = $AddElement
@onready var save_hud_dialog: FileDialog = $Windows/SaveDialog
@onready var open_hud_dialog: FileDialog = $Windows/OpenDialog

@onready var hud_elements: Node = $HUDElements

@onready var saving: Node = $Saving
@onready var loading: Node = $Loading

@onready var camera: Camera2D = $Camera
@onready var ruler_top: EditorRuler = $CanvasLayer/RulerTop
@onready var ruler_left: EditorRuler = $CanvasLayer/RulerLeft

@onready var music: AudioPlayer = $Music
@onready var track_window: Window = $"Windows/Background Track"

func _ready() -> void:
	Audio.stop_music()

	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 0.25)

	save_hud_dialog.root_subfolder = SaveData.path
	open_hud_dialog.root_subfolder = SaveData.path

	loading.load_hud()

	file_menu.get_popup().id_pressed.connect(_file_stuff)
	edit_menu.get_popup().id_pressed.connect(_edit)
	options_menu.get_popup().id_pressed.connect(_options)
	windows_menu.get_popup().id_pressed.connect(_windows)
	add_popup.id_pressed.connect(_add_stuff)
	add_element.id_pressed.connect(_add_element)
	add_popup.popup_hide.connect(func():
		get_tree().create_timer(0.0).timeout.connect(func():
			if hovered_object: hovered_object = null )
	)

	load_background_track("res://assets/music/chartEditorLoop.ogg")

func _process(delta: float) -> void:
	if hovered_object and !add_popup.visible:
		add_popup.set_item_disabled(2, false)
		add_popup.set_item_disabled(3, false)
	elif !hovered_object and !add_popup.visible:
		add_popup.set_item_disabled(2, true)
		add_popup.set_item_disabled(3, true)

	Conductor.position = music.time
	music.volume_db = 80 * (track_volume - 1)
	music.stream_paused = true if track_paused else false

	ruler_top.update_ruler(camera.zoom.x, camera.position - Vector2(640, 360))
	ruler_left.update_ruler(camera.zoom.y, camera.position - Vector2(640, 360))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("hud_exit"):
		Global.switch_scene("res://scenes/menus/options/Menu.tscn")

	if Input.is_action_just_pressed("right_click"):
		add_popup.position = get_viewport().get_mouse_position()
		add_popup.show()

func _file_stuff(id:int):
	var file = file_menu.get_popup()
	print(file.get_item_text(id))
	match file.get_item_text(id):
		"New HUD":
			for i in hud_elements.get_children(): i.queue_free()
		"Open HUD...":
			open_hud_dialog.show()
		"Load Default HUD":
			loading._on_hud_opened("res://assets/defaultHud.json")
		"Save HUD":
			save_hud_dialog.show()
		"Exit":
			Global.switch_scene("res://scenes/menus/options/Menu.tscn")

func _edit(id:int):
	var edit = edit_menu.get_popup()
	match edit.get_item_text(id):
		pass

func _options(id:int):
	match options_menu.get_popup().get_item_text(id):
		"Use downscroll?":
			var is_pressed = not options_menu.get_popup().is_item_checked(id)
			use_donwscroll = is_pressed
			options_menu.get_popup().set_item_checked(id, is_pressed)

func _windows(id:int):
	match windows_menu.get_popup().get_item_text(id):
		"Preferences":
			preferences_window.visible = not preferences_window.visible
		"Background Track":
			track_window.visible = not track_window.visible

func _add_stuff(id:int):
	match add_popup.get_item_text(id):
		"New HUD Element":
			add_element.position = add_popup.position
			add_element.show()
		"Edit HUD Element":
			hovered_object.edit_window.show()
		"Delete HUD Element":
			hovered_object.queue_free()
			hovered_object = null

func _add_element(id:int):
	match add_element.get_item_text(id):
		"New HUDLabel":
			var new_label:HUDEditorLabel = load("res://scenes/menus/options/hud/Elements/HUDEditorLabel.tscn").instantiate()
			hud_elements.add_child(new_label)
			new_label.pos_box_x.value = get_viewport().get_mouse_position().x
			new_label.pos_box_y.value = get_viewport().get_mouse_position().y

func load_background_track(path:String):
	music.stream = load(path)
	music.stream.loop = true
	Conductor.bpm_change_map.clear()
	Conductor.change_bpm(music.stream.bpm)

	music.play()

func _exit_tree() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 1)
