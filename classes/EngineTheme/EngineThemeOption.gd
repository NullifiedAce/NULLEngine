extends OptionButton
class_name EngineThemeOption

@export var data:String = ""

func _ready() -> void:
	selected = EngineTheme.get_theme_data(data)

func _on_item_selected(index: int) -> void:
	EngineTheme.save_theme_data(data, index)
