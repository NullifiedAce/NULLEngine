extends MusicBeatScene

@onready var file_menu: MenuButton = $File
@onready var edit_menu: MenuButton = $Edit
@onready var options_menu: MenuButton = $Options
@onready var help_menu: MenuButton = $Help

@onready var preferences_window: Window = $Preferences
@onready var add_popup: PopupMenu = $AddPopup

func _ready() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 0.25)

	file_menu.get_popup().id_pressed.connect(_file_stuff)
	edit_menu.get_popup().id_pressed.connect(_edit)
	options_menu.get_popup().id_pressed.connect(_options)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("hud_exit"):
		Global.switch_scene("res://scenes/menus/options/Menu.tscn")

	if Input.is_action_just_pressed("right_click"):
		add_popup.position = get_viewport().get_mouse_position()
		add_popup.show()

func _file_stuff(id:int):
	var file = file_menu.get_popup()
	match file.get_item_text(id):
		"Exit":
			Global.switch_scene("res://scenes/menus/options/Menu.tscn")

func _edit(id:int):
	var edit = edit_menu.get_popup()
	match edit.get_item_text(id):
		"Preferences":
			var is_pressed = not edit.is_item_checked(id)
			preferences_window.visible = is_pressed
			edit_menu.get_popup().set_item_checked(id, is_pressed)

func _options(id:int):
	match options_menu.get_popup().get_item_text(id):
		"Use downscroll?":
			var is_pressed = not options_menu.get_popup().is_item_checked(id)
			options_menu.get_popup().set_item_checked(id, is_pressed)

func _exit_tree() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 1)
