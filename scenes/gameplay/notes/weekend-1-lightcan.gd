extends Note

func _cpu_hit() -> void:
	game.opponent.play_anim("light can", true, true)
	Audio.play_sound("weekend1/sounds/Darnell_Lighter")
