extends Node

@onready var bg: BGSprite = $"../CanvasLayer/BG"

func _ready() -> void:
	_on_reload_pressed()

func _on_reload_pressed() -> void:
	bg.color = EngineTheme.get_theme_data("HUD BG Color")
	bg.gradiant = set_gradiant()

func set_gradiant():
	var gradiant = GradientTexture2D.new()

	gradiant.width = 1280
	gradiant.height = 720

	gradiant.fill = GradientTexture2D.FILL_RADIAL
	gradiant.fill_from = Vector2(0.5, 1.0)
	gradiant.fill_to = Vector2(0.5, 0.0)

	var sub_gradiant = Gradient.new()

	sub_gradiant.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CUBIC
	sub_gradiant.offsets = [0.0, 1.0]
	sub_gradiant.colors = [EngineTheme.get_theme_data("HUD BG Gradiant1"), EngineTheme.get_theme_data("HUD BG Gradiant2")]

	gradiant.gradient = sub_gradiant

	return gradiant
