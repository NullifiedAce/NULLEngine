extends SpinBox
class_name OptionsSpinBox

@export var option:String = ""

func _ready() -> void:
	value = SettingsAPI.get_setting(option)

func _on_changed(value: float) -> void:
	SettingsAPI.set_setting(option, not SettingsAPI.get_setting(option))
	SettingsAPI.flush()
	SettingsAPI.update_settings()
