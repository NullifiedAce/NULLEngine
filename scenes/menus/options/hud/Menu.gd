extends MusicBeatScene
class_name HUDEditor

@onready var file_menu: MenuButton = $File
@onready var edit_menu: MenuButton = $Edit
@onready var options_menu: MenuButton = $Options
@onready var help_menu: MenuButton = $Help

@onready var preferences_window: Window = $Preferences
@onready var add_popup: PopupMenu = $AddPopup

@onready var hud_template: HUDElement = $Template


func _ready() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 0.25)

	file_menu.get_popup().id_pressed.connect(_file_stuff)
	edit_menu.get_popup().id_pressed.connect(_edit)
	options_menu.get_popup().id_pressed.connect(_options)
	add_popup.id_pressed.connect(_add_stuff)

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

func _add_stuff(id:int):
	match add_popup.get_item_text(id):
		"Add HUD Element here":
			var new_hud = load("res://scenes/menus/options/hud/Elements/HUDElement.tscn").instantiate()
			add_child(new_hud)

			new_hud.x_pos_box.value = get_viewport().get_mouse_position().x
			new_hud.y_pos_box.value = get_viewport().get_mouse_position().y

func _exit_tree() -> void:
	for i in FPS.get_children():
		i.modulate = Color(1, 1, 1, 1)
