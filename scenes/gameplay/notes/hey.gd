extends Note

func _cpu_hit() -> void:
	game.opponent.play_anim("hey", true, true)

func _player_hit() -> void:
	game.player.play_anim("hey", true, true)
