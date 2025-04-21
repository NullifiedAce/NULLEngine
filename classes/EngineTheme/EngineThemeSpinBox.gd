extends SpinBox
class_name EngineThemeSpinBox

var multiplier:float = 1.0
var def_value:float

@export var data:String = ""

func _ready() -> void:
	def_value = step
	value = EngineTheme.get_theme_data(data)

func _on_value_changed(value: float) -> void:
	EngineTheme.save_theme_data(data, value)

func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_SHIFT): multiplier = 10
	else: multiplier = 1.0

	step = def_value * multiplier
