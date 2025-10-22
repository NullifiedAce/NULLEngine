extends Note

func _cpu_hit() -> void:
	game.opponent.play_anim("knee", true, true)
	Audio.play_sound("weekend1/sounds/Kick_Can_FORWARD")
