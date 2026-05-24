extends MusicBeatScene

var cam_move_multiplier:int = 200

@onready var camera: Camera2D = $Camera2D

@onready var file_popup: PopupMenu = $CanvasLayer/MenuBar/File
@onready var edit_popup: PopupMenu = $CanvasLayer/MenuBar/Edit
@onready var window_popup: PopupMenu = $CanvasLayer/MenuBar/Window
@onready var about_popup: PopupMenu = $CanvasLayer/MenuBar/About

func _ready() -> void:
	FPS.fps_label.modulate = Color(1, 1, 1, 0.75)
	FPS.fps_label.position.y = 664

	file_popup.id_pressed.connect(_handle_file_popup)

func _process(delta: float) -> void:
	var direction_x = Input.get_axis("funkin_left", "funkin_right")
	var direction_y = Input.get_axis("funkin_up", "funkin_down")
	var direction_cam_zoom = Input.get_axis("funkin_switch_left", "funkin_switch_right")

	if Input.is_key_pressed(KEY_SHIFT):
		cam_move_multiplier = 800
	else:
		cam_move_multiplier = 200

	camera.position += Vector2((direction_x*cam_move_multiplier)*delta, (direction_y*cam_move_multiplier)*delta)
	camera.zoom += Vector2(direction_cam_zoom*0.01, direction_cam_zoom*0.01)
	camera.zoom = clamp(camera.zoom, Vector2(0.1, 0.1), Vector2(2.0, 2.0))

	if Input.is_action_just_pressed("funkin_reset"):
		camera.position = Global.game_size/2.0
		camera.zoom = Vector2.ONE

	if Input.is_action_just_pressed("editor_quit"):
		Global.switch_scene("res://scenes/menus/main menu/Menu.tscn")

func _handle_file_popup(id):
	match file_popup.get_item_text(id):
		"Quit":
			Global.switch_scene("res://scenes/menus/main menu/Menu.tscn")

func _exit_tree() -> void:
	FPS.fps_label.modulate = Color(1, 1, 1, 1)
	FPS.fps_label.position.y = 3
