class_name HUDTextButton extends Button

var mouse_hovered:bool = false

@onready var delete_confirmation: PopupMenu = $DeleteConfirmation

@onready var edit_window: Window = $EditWindow
@onready var value_option: OptionButton = $EditWindow/BG/VBoxContainer/Value
@onready var prefix_box: TextEdit = $EditWindow/BG/VBoxContainer/Prefix
@onready var suffix_box: TextEdit = $EditWindow/BG/VBoxContainer/Suffix

func _ready() -> void:
	mouse_entered.connect(func(): mouse_hovered = true)
	mouse_exited.connect(func(): mouse_hovered = false)
	pressed.connect(func():
		edit_window.visible = not edit_window.visible)
	delete_confirmation.id_pressed.connect(_confirm)

func _process(delta: float) -> void:
	text = prefix_box.text + \
	str(Global.gameplay_values[value_option.get_item_text(value_option.selected).to_lower()]) +\
	suffix_box.text

func _input(event: InputEvent):
	if Input.is_key_label_pressed(KEY_DELETE) and mouse_hovered:
		delete_confirmation.position = get_tree().root.get_viewport().get_mouse_position()
		delete_confirmation.show()
		return KEY_DELETE

func _confirm(id:int):
	match delete_confirmation.get_item_text(id):
		"Yes": queue_free()
