extends Label
class_name HUDEditorLabel

var parent = HUDElement

var output_text:String

@onready var customize_window: Window = $CustomizeWindow
@onready var manage_window: Window = $ManageWindow

@onready var alignment: OptionButton = $Alignment

@onready var manage_items: Button = $ManageItems

@onready var font_options: OptionButton = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontOptions
@onready var font_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontColor
@onready var font_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontSize

@onready var outline_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/Outlines/OutlineColor
@onready var outline_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Outlines/OutlineSize

@onready var shadow_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows/ShadowColor
@onready var shadow_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows/ShadowSize
@onready var shadow_offset_x: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows2/ShadowOffsetX
@onready var shadow_offset_y: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows2/ShadowOffsetY

@onready var layout_mode_option: OptionButton = $ManageWindow/ScrollContainer/VBoxContainer/LayoutMode

@onready var item_array: VBoxContainer = $ManageWindow/ScrollContainer/VBoxContainer

func _ready() -> void:
	_on_reload_pressed()

	manage_items.pressed.connect(func():
		if manage_window.visible: manage_window.hide()
		else: manage_window.show())

func _process(delta: float) -> void:
	update_text()

func _on_customize_pressed() -> void:
	if customize_window.visible: customize_window.hide()
	else: customize_window.show()

func _on_reload_pressed() -> void:
	var font_path = load("res://assets/fonts/" + font_options.get_item_text(font_options.selected) + ".ttf")

	add_theme_font_override('font', font_path)
	add_theme_color_override('font_color', font_color_picker.color)
	add_theme_font_size_override('font_size', font_size.value)

	add_theme_color_override('font_outline_color', outline_color_picker.color)
	add_theme_constant_override('outline_size', outline_size.value)

	add_theme_color_override('font_shadow_color', shadow_color_picker.color)
	add_theme_constant_override('shadow_outline_size', shadow_size.value)
	add_theme_constant_override('shadow_offset_x', shadow_offset_x.value)
	add_theme_constant_override('shadow_offset_y', shadow_offset_y.value)

func _on_apply_default_pressed() -> void:
	font_options.selected = EngineTheme.get_theme_data("Label Font")
	font_color_picker.color = Color.from_string(EngineTheme.get_theme_data("Label Font Color"), Color.WHITE)
	font_size.value = EngineTheme.get_theme_data("Label Font Size")

	outline_color_picker.color = Color.from_string(EngineTheme.get_theme_data("Label Outline Color"), Color.BLACK)
	outline_size.value = EngineTheme.get_theme_data("Label Outline Size")

	shadow_color_picker.color = Color.from_string(EngineTheme.get_theme_data("Label Shadow Color"), Color.TRANSPARENT)
	shadow_size.value = EngineTheme.get_theme_data("Label Shadow Size")
	shadow_offset_x.value = EngineTheme.get_theme_data("Label Shadow Offset X")
	shadow_offset_y.value = EngineTheme.get_theme_data("Label Shadow Offset Y")

	_on_reload_pressed()

func move_child_down(node:Button):
	item_array.move_child(node, wrapi(node.get_index() + 1, 3, item_array.get_child_count()))

func move_child_up(node:Button):
	item_array.move_child(node, wrapi(node.get_index() - 1, 3, item_array.get_child_count()))

func _on_add_text_pressed() -> void:
	var item = load("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()
	item_array.add_child(item)

func update_text():
	output_text = ""

	for i in item_array.get_children():
		if i is HUDTextButton:
			if layout_mode_option.selected == 0: output_text += i.output_text
			elif layout_mode_option.selected == 1: output_text += i.output_text + "\n"

	text = output_text
