extends ColorPickerButton
class_name OptionColorPick

@export var option:String = ""

func _ready() -> void:
	color = SettingsAPI.get_setting(option)

func _on_popup_closed() -> void:
	SettingsAPI.set_setting(option, not SettingsAPI.get_setting(option))
	SettingsAPI.flush()
	SettingsAPI.update_settings()
