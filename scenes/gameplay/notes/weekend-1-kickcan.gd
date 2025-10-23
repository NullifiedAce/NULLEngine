extends Note

func _cpu_hit() -> void:
	game.opponent.play_anim("kick", true, true)
	Audio.play_sound("weekend1/Kick_Can_UP")
