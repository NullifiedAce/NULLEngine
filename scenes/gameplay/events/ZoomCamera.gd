extends Event

func _ready() -> void:
	if not parameters.has("zoom"):
		parameters["zoom"] = 1.0
	if not parameters.has("duration"):
		parameters["duration"] = 4.0
	if not parameters.has("mode"):
		parameters["mode"] = "stage"
	if not parameters.has("transitionType"):
		parameters["transitionType"] = Tween.TRANS_LINEAR
	if not parameters.has("easeType"):
		parameters["easeType"] = Tween.EASE_IN

	var durSeconds = Conductor.step_crochet * parameters["duration"] / 1000

	if parameters["mode"] == "stage":
		game.zoom_camera(parameters["zoom"], durSeconds, parameters["transitionType"], parameters["easeType"])
	elif parameters["mode"] == "hud":
		game.hud_zoom(parameters["zoom"], durSeconds, parameters["transitionType"], parameters["easeType"])
