extends Note

func _cpu_hit() -> void:
	pass

func _player_hit() -> void:
	var sing_anim:String = "sing%s" % strumline.get_child(direction).direction.to_upper()
	sing_anim += "-censor"

	game.player.play_anim(sing_anim, true)
	game.player.hold_timer = 0.0
