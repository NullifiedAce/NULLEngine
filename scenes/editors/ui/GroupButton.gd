extends Button
class_name GroupButton

var text_input: String

@export var group:BoxContainer

func _ready() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_NONE

	text_input = text

	toggled.connect(toggle_group)
	toggle_group(false)

func toggle_group(toggled_on: bool):
	if not group:
		push_warning("No group has been assigned to: "+str(self))
		return

	group.visible = toggled_on

	text = " ▼ " + text_input if toggled_on else " ▶ " + text_input
