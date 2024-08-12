extends Button

@export var link: String

func _on_pressed() -> void:
	OS.shell_open(link)
	get_tree().quit()
