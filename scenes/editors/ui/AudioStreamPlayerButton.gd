extends Button

func _ready() -> void:
	toggled.connect(func(toggled_on: bool):
		get_child(0).playing = toggled_on
		icon = load("res://assets/images/material_icons/Editors/Pause.svg") if toggled_on else load("res://assets/images/material_icons/Editors/Play.svg")
	)
