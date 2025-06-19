extends Event

var target: int = -1
var target_pos: Vector2 = Vector2.ZERO
var duration: float = 14.0
var trans_type: Tween.TransitionType = Tween.TRANS_QUINT
var easy_type: Tween.EaseType = Tween.EASE_OUT

func _ready() -> void:
	if parameters.has("char"): target = parameters["char"]

	if parameters.has("x"): target_pos.x =  parameters["x"]

	if parameters.has("y"): target_pos.y = parameters["y"]

	if parameters.has("duration"): duration = parameters["duration"]

	if parameters.has("ease"):
		var ease:String = str(parameters["ease"])
		

	var targetX = target_pos.x
	var targetY = target_pos.y

	if target == -1: # Focusing on a static position.
		pass
	elif target == 0: # Focusing on the player.
		if !game.player:
			push_warning("No BF to focus on.")
			return
		var bfPoint = game.player.camera_pos.global_position + (game.stage.player_cam_offset / game.player.anim_sprite.scale)
		targetX += bfPoint.x
		targetY += bfPoint.y
	elif target == 1: # Focusing on the opponent.
		if !game.opponent:
			push_warning("No dad to focus on.")
			return
		var dadPoint = game.opponent.camera_pos.global_position + (game.stage.opponent_cam_offset / game.opponent.anim_sprite.scale)
		targetX += dadPoint.x
		targetY += dadPoint.y
	elif target == 2: # Focusing on the spectator.
		if !game.spectator:
			push_warning("No GF to focus on.")
			return
		var gfPoint = game.spectator.camera_pos.global_position + (game.stage.spectator_cam_offset / game.spectator.anim_sprite.scale)
		targetX += gfPoint.x
		targetY += gfPoint.y
	else:
		push_warning("Unknown camera focus: " + str(parameters))

	var durSeconds = Conductor.step_crochet * duration / 1000
	if SettingsAPI.get_setting("camera movement"):
		game.update_camera(targetX, targetY, durSeconds, trans_type, easy_type)
	queue_free()
