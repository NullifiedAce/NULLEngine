extends Event

var target

func _ready() -> void:
	if not parameters.has("target"):
		parameters["target"] = "player"
	if not parameters.has("anim"):
		parameters["anim"] = "hey"
	if not parameters.has("force"):
		parameters["force"] = false

	if parameters["target"] == "player":
		print("Playing animation %s on player." % parameters["anim"])
		target = game.player
	if parameters["target"] == "opponent":
		print("Playing animation %s on opponent." % parameters["anim"])
		target = game.opponent
	if parameters["target"] == "spectator":
		print("Playing animation %s on spectator." % parameters["anim"])
		target = game.spectator

	if target is Character:
		target.play_anim(parameters["anim"], parameters["force"])
