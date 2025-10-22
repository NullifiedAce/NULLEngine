extends Event

var target: String = "player"
var anim: String = "hey"
var force: bool = false

var target_char

func _ready() -> void:
	if parameters.has("target"): target = parameters["target"]
	if parameters.has("anim"): anim = parameters["anim"]
	if parameters.has("force"): force = parameters["force"]

	if target == "player" or target == "bf" or target == "boyfriend":
		target_char = game.player
	if target == "opponent" or target == "dad":
		target_char = game.opponent
	if target == "spectator" or target == "gf" or target == "girlfriend":
		target_char = game.spectator

	if target_char is Character:
		target_char.play_anim(anim, force, true)
