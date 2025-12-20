extends Node2D

var charts:Array[Dictionary]

@onready var chart_rect: CodeEdit = $"Converted Panel/TabContainer/Chart"
@onready var metadata_rect: CodeEdit = $"Converted Panel/TabContainer/Metadata"

@onready var file_dialog_window: FileDialog = $FileDialog

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func popup_dialog():
	file_dialog_window.popup_centered()
	file_dialog_window.size = Vector2(500, 500)
	file_dialog_window.position = Vector2(640 - 250, 360 - 250)
