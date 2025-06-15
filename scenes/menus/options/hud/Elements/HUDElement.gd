extends Control
class_name HUDElement

var current_type:int = 0

var use_downscroll:bool = false

var anchor_preset = 0

var hud_label:HUDEditorLabel
var hud_bar:HUDBar

@onready var config: Button = $Config
@onready var move: Button = $Move
@onready var configure_window: Window = $Configure

@onready var options: VBoxContainer = $Configure/ScrollContainer/VBoxContainer

@onready var default_options: VBoxContainer = $'Configure/ScrollContainer/VBoxContainer/Default Options'
@onready var type_options: VBoxContainer = $'Configure/ScrollContainer/VBoxContainer/Type Options' # HUD Elements options will be moved in here.

@onready var type: OptionButton = $'Configure/ScrollContainer/VBoxContainer/Default Options/HBoxContainer/Type'

@onready var x_pos_box: SpinBox = $'Configure/ScrollContainer/VBoxContainer/Default Options/HBoxContainer2/XPos'
@onready var y_pos_box: SpinBox = $'Configure/ScrollContainer/VBoxContainer/Default Options/HBoxContainer2/YPos'
@onready var donwscroll_box: SpinBox = $'Configure/ScrollContainer/VBoxContainer/Default Options/Downscroll SpinBox'

@onready var use_offset: CheckBox = $"Configure/ScrollContainer/VBoxContainer/Default Options/UseOffset"

@onready var rotation_box: SpinBox = $'Configure/ScrollContainer/VBoxContainer/Default Options/Rotation'

@onready var delete_button: Button = $Configure/HBoxContainer/Delete

func _ready() -> void:
	config.pressed.connect(_config_window)
	type.item_selected.connect(_update_type)

	delete_button.pressed.connect(func():
		queue_free())

	_update_type(current_type)

func _process(delta: float) -> void:
	if move.button_pressed:
		position.x = clampf(get_viewport().get_mouse_position().x - 28, 20, 1320)
		position.y = clampf(get_viewport().get_mouse_position().y - 64, -30, 705)
		x_pos_box.value = position.x
		y_pos_box.value = position.y
	else:
		position = Vector2(x_pos_box.value, y_pos_box.value if !use_downscroll else y_pos_box.value * donwscroll_box.value)

	rotation = deg_to_rad(rotation_box.value)

	if position.y >= 660: move.position.y = -48
	else: move.position.y = 48

func _update_type(index:int):
	current_type = index
	for i in type_options.get_children():
		i.queue_free()
	if index == 0:
		if hud_label != null: hud_label.queue_free()
		if hud_bar != null: hud_bar.queue_free()
		hud_label = load("res://scenes/menus/options/hud/Elements/HUDEditorLabel.tscn").instantiate()
		add_child(hud_label)
		for i in hud_label.get_children():
			i.reparent(type_options)
			if i is not Window: i.show()
	if index == 1:
		if hud_label != null: hud_label.queue_free()
		if hud_bar != null: hud_bar.queue_free()
		hud_bar = load("res://scenes/menus/options/hud/Elements/HUDBar.tscn").instantiate()
		add_child(hud_bar)
		for i in hud_bar.get_children():
			i.reparent(type_options)
			if i is not Window: i.show()

func _config_window():
	if configure_window.visible: configure_window.hide()
	else: configure_window.show()

func _on_anchor_pressed(extra_arg_0: int) -> void:
	anchor_preset = extra_arg_0
