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

@onready var preview_icon: Sprite2D = $Window/Preview/PreviewIcon

func _ready() -> void:
	delete.pressed.connect(func():
		queue_free())
	pressed.connect(func():
		if window.visible: window.hide()
		else: window.show())
	icon_type.item_selected.connect(_update_icon)

	_update_icon(0)

func _update_icon(index: int):
	health_icon.texture = load(default_icons[index].resource_path)
	preview_icon.texture = load(default_icons[index].resource_path)
	button_title.text = title[index]
