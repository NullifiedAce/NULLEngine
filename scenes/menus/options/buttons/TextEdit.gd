extends TextEdit
class_name OptionText

@export var option:String = ""

func _ready() -> void:
	text = SettingsAPI.get_setting(option)

func _on_focus_exited() -> void:
	SettingsAPI.set_setting(option, text)
	SettingsAPI.flush()

	SettingsAPI.update_settings()
