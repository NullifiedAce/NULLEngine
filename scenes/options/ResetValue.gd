extends Button

@export var defValue: Color
var option:String = ""

func _process(delta: float) -> void:
	if get_parent().color != defValue:
		visible = true
	else:
		visible = false

func _on_pressed() -> void:
	get_parent().color = defValue
	visible = false

	option = get_parent().option
	SettingsAPI.set_setting(option, get_parent().color)
	SettingsAPI.flush()
	SettingsAPI.update_settings()
