extends Event

var intensity: float = 1.0
var rate: int = 4

func _ready() -> void:
	if parameters.has("intensity"): intensity = parameters["intensity"]

	if parameters.has("rate"): rate = parameters["rate"] 

	game.camera_bop_intensitiy = (Constants.DEFAULT_BOP_INTENSITY - 1.0) * intensity
	game.hud_zoom_intensitiy = (Constants.DEFAULT_BOP_INTENSITY - 1.0) * intensity * 2.0
	game.camera_zoom_rate = rate
