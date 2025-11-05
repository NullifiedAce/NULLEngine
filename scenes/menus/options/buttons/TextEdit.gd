extends TextEdit
class_name OptionText

@export var option:String = ""

func _ready() -> void:
	text = OptionsAPI.get_option(option)

func _on_focus_exited() -> void:
	OptionsAPI.set_option(option, text)
	OptionsAPI.flush()

	OptionsAPI.update_settings()

func _on_text_changed() -> void:
	OptionsAPI.set_option(option, text)
	OptionsAPI.flush()

	OptionsAPI.update_settings()
