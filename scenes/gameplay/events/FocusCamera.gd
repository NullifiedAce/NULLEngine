extends Event

func _ready() -> void:
	if not parameters.has("target"):
		parameters["target"] = -1
	if not parameters.has("x"):
		parameters["x"] = 0
	if not parameters.has("y"):
		parameters["y"] = 0
	if not parameters.has("duration"):
		parameters["duration"] = 4
	if not parameters.has("transitionType"):
		parameters["transitionType"] = Tween.TRANS_SINE
	if not parameters.has("easeType"):
		parameters["easeType"] = Tween.EASE_OUT

	var targetX = parameters["x"]
	var targetY = parameters["y"]

	if parameters["target"] == -1:
		print("Focusing camera on static position.")
	elif parameters["target"] == 0:
		if !game.player:
			push_warning("No BF to focus on.")
			return
		print("Focusing camera on player.")
		var bfPoint = game.player.camera_pos.global_position + game.stage.player_cam_offset
		targetX += bfPoint.x
		targetY += bfPoint.y
	elif parameters["target"] == 1:
		if !game.opponent:
			push_warning("No dad to focus on.")
			return
		print("Focusing camera on opponent.")
		var dadPoint = game.opponent.camera_pos.global_position + game.stage.opponent_cam_offset
		targetX += dadPoint.x
		targetY += dadPoint.y
	elif parameters["target"] == 2:
		if !game.spectator:
			push_warning("No GF to focus on.")
			return
		print("Focusing camera on spectator.")
		var gfPoint = game.spectator.camera_pos.global_position + game.stage.spectator_cam_offset
		targetX += gfPoint.x
		targetY += gfPoint.y
	else:
		push_warning("Unknown camera focus: " + str(parameters))

	var durSeconds = Conductor.step_crochet * parameters["duration"] / 1000
	if SettingsAPI.get_setting("camera movement"):
		game.update_camera(targetX, targetY, durSeconds, parameters["transitionType"], parameters["easeType"])
	queue_free()
