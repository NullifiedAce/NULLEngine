extends CanvasLayer

@onready var preview_text: Label = $Preview
var text_length: int = 0

var temp_array = []

func _ready() -> void:
	var array = SettingsAPI.get_setting("score_arrangement")

	preview_text.text = ""
	print(array)
	temp_array = str_to_var(array)

func _process(_delta: float) -> void:
	preview_text.text = ""
	text_length = 0

	for i in temp_array:
		text_length += 1
		if text_length == temp_array.size():
			preview_text.text += str(i).capitalize()
		else:
			preview_text.text += str(i).capitalize() + ", "

func _on_clear_pressed() -> void:
	temp_array.clear()

func _on_delete_pressed() -> void:
	if temp_array.size() != 0:
		temp_array.resize(temp_array.size() - 1)

func _on_done_button_down() -> void:
	SettingsAPI.set_setting("score_arrangement", var_to_str(temp_array))
	SettingsAPI.flush()

	hide()
