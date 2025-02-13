extends Stage

@onready var rain: ColorRect = $'0-8/rain'

@export var intensity: float = 1.0
@export var rain_scale: float = 1.0
@export_color_no_alpha var rain_color: Color = Color(0.2, 0.3, 0.4)

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	rain.material.set_shader_parameter("uTime", time)
	rain.material.set_shader_parameter("uIntensity", intensity)
	rain.material.set_shader_parameter("uScale", rain_scale)
	rain.material.set_shader_parameter("uRainColor", rain_color)
