extends CanvasLayer

@onready var preview_text: Label = $Preview

var preview_text_settings = LabelSettings.new()
var preview_text_bg = StyleBoxFlat.new()

func _process(delta: float) -> void:
	if Global.update_options:
		setup_label_settings()
		preview_text.label_settings = preview_text_settings
		preview_text.add_theme_stylebox_override("normal", preview_text_bg)

func setup_label_settings():
	preview_text_settings.font = load(SettingsAPI.get_setting("font path"))
	preview_text_settings.font_size = SettingsAPI.get_setting("font size")
	preview_text_settings.font_color = SettingsAPI.get_setting("font color")

	preview_text_settings.outline_size = SettingsAPI.get_setting("outline size")
	preview_text_settings.outline_color = SettingsAPI.get_setting("outline color")

	preview_text_bg.bg_color = Color.from_string(SettingsAPI.get_setting("score bg color"), Color.WHITE)
	preview_text_bg.expand_margin_bottom = SettingsAPI.get_setting("score bg expand")
	preview_text_bg.expand_margin_left = SettingsAPI.get_setting("score bg expand")
	preview_text_bg.expand_margin_right = SettingsAPI.get_setting("score bg expand")
	preview_text_bg.expand_margin_top = SettingsAPI.get_setting("score bg expand")


func _on_auto_size_pressed() -> void:
	$'Shadow/Shadow Size'.value = SettingsAPI.get_setting("font size") / 2

func _on_done_pressed() -> void:
	SettingsAPI.flush()
	hide()

func _on_load_font_pressed() -> void:
	$openFont.show()

func _on_open_font_file_selected(path: String) -> void:
	SettingsAPI.set_setting("font path", path)
