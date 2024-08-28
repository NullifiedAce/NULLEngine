extends CanvasLayer

@onready var hp_bar_x: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar X'
@onready var hp_bar_y: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar Y'

func _process(delta: float) -> void:
	if Global.update_options:
		if SettingsAPI.get_setting("downscroll"):
			$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y.value * 0.1)
		else:
			$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y.value)

		if SettingsAPI.get_setting("hide hpbar"):
			$HealthBar.self_modulate = Color(1, 1, 1, 0)
			$HealthBar/ProgressBar.self_modulate  = Color(1, 1, 1, 0)
		else:
			$HealthBar.self_modulate = Color(1, 1, 1, 1)
			$HealthBar/ProgressBar.self_modulate  = Color(1, 1, 1, 1)

		if SettingsAPI.get_setting("hide icons"):
			$HealthBar/ProgressBar/PlayerIcon.hide()
			$HealthBar/ProgressBar/CPUIcon.hide()
		else:
			$HealthBar/ProgressBar/PlayerIcon.show()
			$HealthBar/ProgressBar/CPUIcon.show()

		setup_label_settings()

func setup_label_settings():
	var text_settings = LabelSettings.new()
	var text_bg = StyleBoxFlat.new()

	text_settings.font = load(SettingsAPI.get_setting("font path"))
	text_settings.font_size = SettingsAPI.get_setting("font size")
	text_settings.font_color = SettingsAPI.get_setting("font color")

	text_settings.outline_size = SettingsAPI.get_setting("outline size")
	text_settings.outline_color = SettingsAPI.get_setting("outline color")

	text_bg.bg_color = Color.from_string(SettingsAPI.get_setting("score bg color"), Color.WHITE)
	text_bg.expand_margin_bottom = SettingsAPI.get_setting("score bg expand")
	text_bg.expand_margin_left = SettingsAPI.get_setting("score bg expand")
	text_bg.expand_margin_right = SettingsAPI.get_setting("score bg expand")
	text_bg.expand_margin_top = SettingsAPI.get_setting("score bg expand")

	$HealthBar/ScoreText.label_settings = text_settings
	$HealthBar/ScoreText.add_theme_stylebox_override("normal", text_bg)
