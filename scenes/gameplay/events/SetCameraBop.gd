extends Event

func _ready() -> void:
	if not parameters.has("intensity"):
		parameters["intensity"] = 1.0
	if not parameters.has("rate"):
		parameters["rate"] = 4

	game.camera_bop_intensitiy = (Constants.DEFAULT_BOP_INTENSITY - 1.0) * parameters["intensity"]
	game.hud_zoom_intensitiy = (Constants.DEFAULT_BOP_INTENSITY - 1.0) * parameters["intensity"] * 2.0
	game.camera_zoom_rate = parameters["rate"]
