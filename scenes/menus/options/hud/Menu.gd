extends MusicBeatScene

@onready var file_popup: PopupMenu = $CanvasLayer/MenuBar/File
@onready var edit_popup: PopupMenu = $CanvasLayer/MenuBar/Edit
@onready var windows_popup: PopupMenu = $CanvasLayer/MenuBar/Windows
@onready var help_popup: PopupMenu = $CanvasLayer/MenuBar/Help


func _ready() -> void:
	FPS.fps_label.modulate = Color.TRANSPARENT
	FPS.mem_label.modulate = Color.TRANSPARENT

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	RichPresence.set_text("In the menu", "HUD Editor")

func _on_file_id_pressed(id: int) -> void:
	var item = file_popup.get_item_text(id)

	match item:
		"Exit":
			Global.switch_scene("res://scenes/menus/options/Menu.tscn")
