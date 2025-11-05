extends ColorPickerButton
class_name OptionColorPick

@export var option:String = ""

func _ready() -> void:
	print(OptionsAPI.get_option(option))
	color = Color.from_string(OptionsAPI.get_option(option), Color.TRANSPARENT)
	#color = OptionsAPI.get_option(option)

func _on_popup_closed() -> void:
	OptionsAPI.set_option(option, color.to_html())
	OptionsAPI.flush()

	OptionsAPI.update_settings()
