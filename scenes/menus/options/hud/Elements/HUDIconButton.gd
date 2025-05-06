extends Button

## Icons shown for the button itself.
@export var default_icons:Array[Texture2D]

## Title text
@export var title:Array[String]

@onready var delete: Button = $Delete
@onready var health_icon: Sprite2D = $Icon
@onready var button_title: Label = $Title
@onready var icon_type: OptionButton = $Window/ScrollContainer/VBoxContainer/HBoxContainer/IconType
@onready var window: Window = $Window

@onready var hue_value: SpinBox = $Window/ScrollContainer/VBoxContainer/Appearance/Hue
@onready var saturation_value: SpinBox = $Window/ScrollContainer/VBoxContainer/Appearance/Saturation
@onready var brightness_value: SpinBox = $Window/ScrollContainer/VBoxContainer/Appearance2/Brightness
@onready var contrast_value: SpinBox = $Window/ScrollContainer/VBoxContainer/Appearance2/Contrast
@onready var alpha_value: SpinBox = $Window/ScrollContainer/VBoxContainer/Appearance3/Alpha
@onready var reload_button: Button = $Window/ScrollContainer/VBoxContainer/Appearance3/ReloadButton

@onready var preview_icon: Sprite2D = $Window/Preview/PreviewIcon

func _ready() -> void:
	delete.pressed.connect(func():
		queue_free())
	pressed.connect(func():
		if window.visible: window.hide()
		else: window.show())
	icon_type.item_selected.connect(_update_icon)

	reload_button.pressed.connect(apply_changes)

	_update_icon(0)

func _update_icon(index: int):
	health_icon.texture = load(default_icons[index].resource_path)
	preview_icon.texture = load(default_icons[index].resource_path)
	button_title.text = title[index]

func apply_changes():
	preview_icon.material.set_shader_parameter("hue", hue_value.value)
	preview_icon.material.set_shader_parameter("saturation", saturation_value.value)
	preview_icon.material.set_shader_parameter("brightness", brightness_value.value)
	preview_icon.material.set_shader_parameter("contrast", contrast_value.value)
	preview_icon.material.set_shader_parameter("alpha", alpha_value.value)
