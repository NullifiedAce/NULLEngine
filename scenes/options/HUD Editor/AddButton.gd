extends Button
class_name AddItemButton
## Intended to be only used in HUD Editor. Otherwise might cause errors or crashes.

@onready var parent: CanvasLayer = $'../../..'
@export var add_item: String

func _on_pressed() -> void:
	parent.temp_array.append(add_item)
