extends HSlider
class_name OptionSlider

@export var option:String = ""

func _ready():
	value = OptionsAPI.get_option(option)

func _on_value_changed(value:float):
	OptionsAPI.set_option(option, value)

func _on_drag_ended(value_changed:bool):
	if not value_changed: return
	OptionsAPI.flush()

	OptionsAPI.update_settings()
