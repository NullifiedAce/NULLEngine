extends OptionButton

func _ready():
	text = str(OptionsAPI.get_option("fps"))

func _on_item_selected(index:int):
	OptionsAPI.set_option("fps", int(text))
	OptionsAPI.flush()
	OptionsAPI.update_settings()
