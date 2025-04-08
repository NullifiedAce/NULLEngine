extends ColorPickerButton
class_name OptionColorPick

@export var option:String = ""

func _ready() -> void:
	print(SettingsAPI.get_setting(option))
	color = Color.from_string(SettingsAPI.get_setting(option), Color.TRANSPARENT)
	#color = SettingsAPI.get_setting(option)

func _on_popup_closed() -> void:
	SettingsAPI.set_setting(option, color.to_html())
	SettingsAPI.flush()

	SettingsAPI.update_settings()
