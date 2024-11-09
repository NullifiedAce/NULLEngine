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
		parameters[4] = Tween.TRANS_LINEAR
	if parameters[5] == null:
		parameters[5] = Tween.EASE_IN

	var targetX = parameters[1]
	var targetY = parameters[2]

	match parameters[0]:
		-1: # Position ("focus" on origin)
			print("Focusing camera on static position.")

		0: # Boyfriend (focus on player)
			if !game.player:
				push_warning("No BF to focus on.")
				return
			print("Focusing camera on player.")
			var bfPoint = game.player.camera_pos.position
			targetX += bfPoint.x
			targetY += bfPoint.y

		1: # Dad (focus on opponent)
			if !game.opponent:
				push_warning("No dad to focus on.")
				return
			print("Focusing camera on opponent.")
			var dadPoint = game.opponent.camera_pos.position
			targetX += dadPoint.x
			targetY += dadPoint.y

		2: # Girlfriend (focus on girlfriend)
			if !game.spectator:
				push_warning("No GF to focus on.")
				return
			print("Focusing camera on opponent.")
			var gfPoint = game.spectator.camera_pos.position
			targetX += gfPoint.x
			targetY += gfPoint.y

		_:
			push_warning("Unknown camera focus: " + str(parameters))

	var durSeconds = Conductor.step_crochet * parameters[3] / 1000
	game.update_camera(targetX, targetY, durSeconds, parameters[4], parameters[5])
