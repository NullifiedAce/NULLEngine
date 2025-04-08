extends SpinBox

var multiplier:float = 1.0
var def_value:float

func _ready() -> void:
	def_value = step

func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_SHIFT): multiplier = 10
	else: multiplier = 1.0

	step = def_value * multiplier
