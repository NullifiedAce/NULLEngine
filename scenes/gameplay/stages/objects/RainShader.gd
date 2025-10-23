extends ColorRect

@export var intensity: float = 1.0
@export var rain_scale: float = 1.0
@export var rain_color: Color = Color(0.2, 0.3, 0.4)

var time: float = 0.0
var rain_time_scale: float = 1.0

func _process(delta: float) -> void:
	time += rain_time_scale
	material.set_shader_parameter("uTime", time)
	material.set_shader_parameter("uIntensity", intensity)
	material.set_shader_parameter("uScale", rain_scale)
	material.set_shader_parameter("uRainColor", rain_color)
