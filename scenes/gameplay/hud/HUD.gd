extends CanvasLayer
class_name HUD

@onready var game: Gameplay = $'..'

func _ready() -> void:
	setup_labels()

func setup_labels():
	for i in HUDHandler.hud_labels:
		var new_label = load("res://scenes/gameplay/hud/Objects/HUDLabel.tscn").instantiate()
		new_label.position = i.position
		new_label.downscroll_multiplier = i.downscroll_multiplier
		new_label.rotation = i.rotation
		new_label.text = i.text
		new_label.track_value = i.track_value
		new_label.track = i.track
		new_label.prefix = i.prefix
		new_label.suffix = i.suffix
		setup_label_style(new_label, {
			"font": i.font,
			"font color": i.font_color,
			"font size": i.font_size,
			"outline color": i.outline_color,
			"outline size": i.outline_size,
			"shadow color": i.shadow_color,
			"shadow size": i.shadow_size,
			"shadow offset x": i.shadow_offset_x,
			"shadow offset y": i.shadow_offset_y,
		})
		add_child(new_label)

func setup_label_style(label:HUDLabel, values:Dictionary):
	var font_path = load("res://assets/fonts/" + values["font"] + ".ttf")

	label.add_theme_font_override('font', font_path)
	label.add_theme_color_override('font_color', Color.from_string(values["font color"], Color.WHITE))
	label.add_theme_font_size_override('font_size', values["font size"])

	label.add_theme_color_override('font_outline_color', Color.from_string(values["outline color"], Color.BLACK))
	label.add_theme_constant_override('outline_size', values["outline size"])

	label.add_theme_color_override('font_shadow_color', Color.from_string(values["shadow color"], Color.TRANSPARENT))
	label.add_theme_constant_override('shadow_outline_size', values["shadow size"])
	label.add_theme_constant_override('shadow_offset_x', values["shadow offset x"])
	label.add_theme_constant_override('shadow_offset_y', values["shadow offset y"])
