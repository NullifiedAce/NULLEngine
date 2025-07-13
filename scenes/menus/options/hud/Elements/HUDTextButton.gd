class_name HUDTextButton extends Button

var mouse_hovered:bool = false

@onready var delete_confirmation: PopupMenu = $DeleteConfirmation

func _ready() -> void:
	mouse_entered.connect(func(): mouse_hovered = true)
	mouse_exited.connect(func(): mouse_hovered = false)
	delete_confirmation.id_pressed.connect(_confirm)

func _input(event: InputEvent):
	if Input.is_key_label_pressed(KEY_DELETE) and mouse_hovered:
		delete_confirmation.position = get_tree().root.get_viewport().get_mouse_position()
		delete_confirmation.show()
		return KEY_DELETE

func _confirm(id:int):
	match delete_confirmation.get_item_text(id):
		"Yes": queue_free()
