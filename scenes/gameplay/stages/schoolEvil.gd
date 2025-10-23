extends Stage

@onready var school: Sprite2D = $"0-75/school"
@onready var weeb_back_trees: Sprite2D = $"0-5/weebBackTrees"
@onready var street: Sprite2D = $street
@onready var trees: Sprite2D = $trees

@onready var school_shader: ShaderMaterial = school.material
@onready var weeb_back_trees_shader: ShaderMaterial = weeb_back_trees.material
@onready var street_shader: ShaderMaterial = street.material
@onready var trees_shader: ShaderMaterial = trees.material

func _ready():
	pass

func _process(delta: float) -> void:
	school_shader.set_shader_parameter("uTime", school_shader.get_shader_parameter("uTime") + delta)
	weeb_back_trees_shader.set_shader_parameter("uTime", weeb_back_trees_shader.get_shader_parameter("uTime") + delta)
	street_shader.set_shader_parameter("uTime", street_shader.get_shader_parameter("uTime") + delta)
	trees_shader.set_shader_parameter("uTime", trees_shader.get_shader_parameter("uTime") + delta)
