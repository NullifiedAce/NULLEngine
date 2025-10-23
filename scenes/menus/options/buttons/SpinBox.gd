extends SpinBox
class_name OptionsSpinBox

@export var option:String = ""

var def_step:float
var multiplier:float = 1.0

func _ready() -> void:
	value = SettingsAPI.get_setting(option)
	def_step = step

func _input(event: InputEvent) -> void:
	if Input.is_key_label_pressed(KEY_SHIFT): multiplier = 10.0
	elif Input.is_key_label_pressed(KEY_CTRL): multiplier = 100.0
	else: multiplier = 1.0

func _process(delta: float) -> void:
	step = def_step * multiplier

func _on_changed(value: float) -> void:
	SettingsAPI.set_setting(option, value)
	SettingsAPI.flush()
	SettingsAPI.update_settings()
