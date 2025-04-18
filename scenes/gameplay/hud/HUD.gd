extends CanvasLayer
class_name HUD

@onready var game: Gameplay = $'..'

func _ready() -> void:
	setup_labels()

func setup_labels():
	for i in HUDHandler.hud_labels:
		var new_label = load("res://scenes/gameplay/hud/Objects/HUDLabel.tscn").instantiate()
		new_label.position = i.position
		new_label.downscroll_multiplier = i.downscroll_multiplier
		new_label.rotation = deg_to_rad(i.rotation)
		new_label.text = i.text
		new_label.track_value = i.track_value
		new_label.track = i.track
		new_label.prefix = i.prefix
		new_label.suffix = i.suffix0
		add_child(new_label)
