extends Event

var target: int = -1
var target_pos: Vector2 = Vector2.ZERO
var duration: float = 14.0
var trans_type: Tween.TransitionType = Tween.TRANS_QUINT
var ease_type: Tween.EaseType = Tween.EASE_OUT

func _ready() -> void:
	if parameters.has("char"): target = int(parameters["char"])
	if parameters.has("target"): target = int(parameters["target"])
	if parameters.has("x"): target_pos.x =  float(parameters["x"])
	if parameters.has("y"): target_pos.y = float(parameters["y"])
	if parameters.has("duration"): duration = parameters["duration"]
	if parameters.has("ease"):
		if !parameters["ease"] == "CLASSIC":
			var ease_data = Global.parse_ease(parameters["ease"])
			trans_type = ease_data.trans_type
			ease_type = ease_data.ease_type
		else:
			duration = 14.0
			trans_type = Tween.TRANS_QUINT
			ease_type = Tween.EASE_OUT

	var targetX = target_pos.x
	var targetY = target_pos.y

	if target == -1: # Focusing on a static position.
		pass
	elif target == 0: # Focusing on the player.
		if !game.player:
			push_warning("No BF to focus on.")
			return
		var bfPoint = game.player.camera_pos.global_position + game.stage.player_cam_offset
		targetX += bfPoint.x
		targetY += bfPoint.y
	elif target == 1: # Focusing on the opponent.
		if !game.opponent:
			push_warning("No dad to focus on.")
			return
		var dadPoint = game.opponent.camera_pos.global_position + game.stage.opponent_cam_offset
		targetX += dadPoint.x
		targetY += dadPoint.y
	elif target == 2: # Focusing on the spectator.
		if !game.spectator:
			push_warning("No GF to focus on.")
			return
		var gfPoint = game.spectator.camera_pos.global_position + game.stage.spectator_cam_offset
		targetX += gfPoint.x
		targetY += gfPoint.y
	else:
		push_warning("Unknown camera focus: " + str(parameters))

	var durSeconds = Conductor.step_crochet/1000*duration
	if SettingsAPI.get_setting("camera movement"):
		game.update_camera(targetX, targetY, durSeconds, trans_type, ease_type)
	queue_free()
