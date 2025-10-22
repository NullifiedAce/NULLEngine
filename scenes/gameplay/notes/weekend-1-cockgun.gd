extends Note

func _player_hit() -> void:
	game.player.play_anim("cock", true, true)
	Audio.play_sound("weekend1/Gun_Prep")
