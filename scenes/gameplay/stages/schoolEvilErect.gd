extends Stage

@onready var school: Sprite2D = $"0-75/school"
@onready var back_spike: Sprite2D = $"0-85/backSpike"
@onready var backspikes: Sprite2D = $"0-5/backspikes"
@onready var street: Sprite2D = $street


@onready var school_shader: ShaderMaterial = school.material
@onready var back_spike_shader: ShaderMaterial = back_spike.material
@onready var street_shader: ShaderMaterial = street.material
@onready var backspikes_shader: ShaderMaterial = backspikes.material

func _ready():
	pass

func _process(delta: float) -> void:
	school_shader.set_shader_parameter("uTime", school_shader.get_shader_parameter("uTime") + delta)
	back_spike_shader.set_shader_parameter("uTime", back_spike_shader.get_shader_parameter("uTime") + delta)
	street_shader.set_shader_parameter("uTime", street_shader.get_shader_parameter("uTime") + delta)
	backspikes_shader.set_shader_parameter("uTime", backspikes_shader.get_shader_parameter("uTime") + delta)
