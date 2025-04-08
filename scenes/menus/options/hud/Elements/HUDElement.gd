extends Control
class_name HUDElement

var hud_label:HUDLabel

var update_values:bool = true

@onready var default_children: VBoxContainer = $VBoxContainer

@onready var config: Button = $Config
@onready var move: Button = $Move
@onready var configure_window: Window = $Configure

@onready var options: VBoxContainer = $Configure/ScrollContainer/VBoxContainer

@onready var type: OptionButton = $Configure/ScrollContainer/VBoxContainer/HBoxContainer/Type

@onready var x_pos_box: SpinBox = $Configure/ScrollContainer/VBoxContainer/HBoxContainer2/XPos
@onready var y_pos_box: SpinBox = $Configure/ScrollContainer/VBoxContainer/HBoxContainer2/YPos

func _ready() -> void:
	config.pressed.connect(_config_window)
	type.item_selected.connect(_update_type)

func _process(delta: float) -> void:
	if move.button_pressed:
		if !update_values: return
		position.x = clampf(get_viewport().get_mouse_position().x + 28, 20, 1320)
		position.y = clampf(get_viewport().get_mouse_position().y - 56, -30, 705)
		x_pos_box.value = position.x
		y_pos_box.value = position.y
	else:
		if !update_values:
			return
		else:
			position = Vector2(x_pos_box.value, y_pos_box.value)

	if position.y >= 660: move.position.y = -48
	else: move.position.y = 48

func _update_type(index:int):
	if index == 0:
		if hud_label != null: hud_label.queue_free()
		hud_label = load("res://scenes/menus/options/hud/Elements/HUDLabel.tscn").instantiate()
		add_child(hud_label)
		for i in hud_label.get_children():
			print("hi")
			i.reparent(options)
			i.show()

func _config_window():
	if configure_window.visible: configure_window.hide()
	else: configure_window.show()
