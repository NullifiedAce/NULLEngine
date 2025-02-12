extends FunkinScript

func _process(delta: float) -> void:
	game.cpu_strums.modulate = Color.TRANSPARENT
	game.player_strums.position.x = Global.game_size.x / 2 # Forced middlescroll :P

func on_note_hit(note:Note):
	game.stage.rain_time_scale += 0.7

	match note.note_type:
		"weekend-1-punchlow":
			play_punch_low()
		"weekend-1-punchlowblocked":
			play_punch_low()
		"weekend-1-punchlowdodged":
			play_punch_low()
		"weekend-1-punchlowspin":
			play_punch_low()

		"weekend-1-punchhigh":
			play_punch_high_anim();
		"weekend-1-punchhighblocked":
			play_punch_high_anim();
		"weekend-1-punchhighdodged":
			play_punch_high_anim();
		"weekend-1-punchhighspin":
			play_punch_high_anim();

		"weekend-1-blockhigh":
			play_block_anim()
		"weekend-1-blocklow":
			play_block_anim()
		"weekend-1-blockspin":
			play_block_anim()

		"weekend-1-dodgehigh":
			play_dodge_anim()
		"weekend-1-dodgelow":
			play_dodge_anim()
		"weekend-1-dodgespin":
			play_dodge_anim()

		"weekend-1-hithigh":
			play_hit_high_anim()
		"weekend-1-hitlow":
			play_hit_low_anim()
		"weekend-1-hitspin":
			play_spin_anim()

		"weekend-1-picouppercutprep":
			play_uppercut_prep_anim()
		"weekend-1-picouppercut":
			play_uppercut_anim(true)

func play_punch_low():
	game.player.play_anim("punch low", true, true)

func play_punch_high_anim():
	game.player.play_anim("punch high", true, true)

func play_block_anim():
	game.player.play_anim("block", true, true)

func play_dodge_anim():
	game.player.play_anim("dodge", true, true)

func play_hit_high_anim():
	game.player.play_anim("hit high", true, true)

func play_hit_low_anim():
	game.player.play_anim("hit low", true, true)

func play_spin_anim():
	game.player.play_anim("duck", true, true)

func play_uppercut_prep_anim():
	game.player.play_anim("upperCut", true, true)

func play_uppercut_anim(hit:bool):
	game.player.play_anim("upperCut", true, true)
