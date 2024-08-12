@tool
extends Sprite2D
class_name BGSprite
## Funkin' Menu Background

@export_group("BG Sprite")
@export var color = Color8(255, 255, 255, 255)
@export var gradiant: GradientTexture2D

func _process(delta: float) -> void:
	self_modulate = color
	$Gradiant.texture = gradiant
