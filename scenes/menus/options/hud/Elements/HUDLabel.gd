extends Label
class_name HUDLabel

var parent = HUDElement

@onready var label_text: TextEdit = $Text
@onready var track_value_check: CheckBox = $Tracker
@onready var track_value: OptionButton = $TrackValue
@onready var prefix_box: TextEdit = $Prefix
@onready var suffix_box: TextEdit = $Suffix

@onready var customize_window: Window = $CustomizeWindow

@onready var font_options: OptionButton = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontOptions
@onready var font_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontColor
@onready var font_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/HBoxContainer/FontSize
@onready var outline_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/Outlines/OutlineColor
@onready var outline_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Outlines/OutlineSize
@onready var shadow_color_picker: ColorPickerButton = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows/ShadowColor
@onready var shadow_size: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows/ShadowSize
@onready var shadow_offset_x: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows2/ShadowOffsetX
@onready var shadow_offset_y: SpinBox = $CustomizeWindow/ScrollContainer/VBoxContainer/Shadows2/ShadowOffsetY

func _ready() -> void:
	_on_reload_pressed()

func _process(delta: float) -> void:
	if !track_value_check.button_pressed:
		text = label_text.text
	else:
		text = prefix_box.text + "0" + suffix_box.text

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
