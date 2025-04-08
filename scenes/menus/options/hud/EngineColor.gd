extends ColorPickerButton
class_name EngineThemeColor

@export var data:String = ""

func _ready() -> void:
	color = Color.from_string(EngineTheme.get_theme_data(data), Color.TRANSPARENT)

func _on_popup_closed() -> void:
	EngineTheme.save_theme_data(data, color.to_html())
