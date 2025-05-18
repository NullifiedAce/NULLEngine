extends Event

var zoom: float = 1.0
var duration: float = 4.0
var mode: String = "stage"
var trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
var ease_type: Tween.EaseType = Tween.EASE_IN

func _ready() -> void:
	if parameters.has("zoom"): zoom = parameters["zoom"]

	if parameters.has("duration"): duration = parameters["duration"]

	if parameters.has("mode"): mode = parameters["mode"]

	if parameters.has("transitionType"): trans_type = parameters["transitionType"]

	if parameters.has("easeType"): ease_type = parameters["easeType"]

	var durSeconds = Conductor.step_crochet * duration / 1000

	if parameters["mode"] == "stage":
		game.zoom_camera(zoom, durSeconds, trans_type, ease_type)
	elif parameters["mode"] == "hud":
		game.hud_zoom(zoom, durSeconds, trans_type, ease_type)
