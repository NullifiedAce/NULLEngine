extends Event

func _ready() -> void:
	if parameters.size() < 6:
		parameters.resize(6)

	if parameters[0] == null:
		parameters[0] = -1
	if parameters[1] == null:
		parameters[1] = 0
	if parameters[2] == null:
		parameters[2] = 0
	if parameters[3] == null:
		parameters[3] = 4
	if parameters[4] == null:
		parameters[4] = Tween.TRANS_QUAD
	if parameters[5] == null:
		parameters[5] = Tween.EASE_OUT

	var targetX = parameters[1]
	var targetY = parameters[2]

	if parameters[0] == -1:
		print("Focusing camera on static position.")
	elif parameters[0] == 0:
		if !game.player:
			push_warning("No BF to focus on.")
			return
		print("Focusing camera on player.")
		var bfPoint = game.player.camera_pos.global_position
		targetX += bfPoint.x
		targetY += bfPoint.y
	elif parameters[0] == 1:
		if !game.opponent:
			push_warning("No dad to focus on.")
			return
		print("Focusing camera on opponent.")
		var dadPoint = game.opponent.camera_pos.global_position
		targetX += dadPoint.x
		targetY += dadPoint.y
	elif parameters[0] == 2:
		if !game.spectator:
			push_warning("No GF to focus on.")
			return
		print("Focusing camera on opponent.")
		var gfPoint = game.spectator.camera_pos.global_position
		targetX += gfPoint.x
		targetY += gfPoint.y
	else:
		push_warning("Unknown camera focus: " + str(parameters))

	var durSeconds = Conductor.step_crochet * parameters[3] / 1000
	game.update_camera(targetX, targetY, durSeconds, parameters[4], parameters[5])
	queue_free()
