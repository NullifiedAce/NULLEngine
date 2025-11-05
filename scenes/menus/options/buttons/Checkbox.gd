extends CheckBox
class_name OptionCheckbox

@export var option:String = ""

func _ready() -> void:
	button_pressed = OptionsAPI.get_option(option)

func _on_pressed() -> void:
	Audio.play_sound("scrollMenu")

	OptionsAPI.set_option(option, not OptionsAPI.get_option(option))
	OptionsAPI.flush()

	OptionsAPI.update_settings()
