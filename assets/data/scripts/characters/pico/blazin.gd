extends FunkinScript

var cant_uppercut:bool = false

var player

func _ready_post() -> void:
	player = game.player

	player.play_anim("idle")

	player.anim_player.speed_scale = 1.1

func _process(delta: float) -> void:
	game.cpu_strums.modulate = Color.TRANSPARENT
	game.player_strums.position.x = Global.game_size.x / 2 #  Forced middlescroll :P

	game.hud_zoom_intensitiy = 0.0

func move_to_back():
	player.z_index = 2000

func move_to_front():
	player.z_index = 3000

func on_note_hit(note:Note):

	game.stage.rain_time_scale += 0.7

	game.camera_shake(10.0, 10.0, true, true)

	player.hold_timer = 0

	match note.note_type:
		"weekend-1-punchlow":
			play_punch_low_anim();
		"weekend-1-punchlowblocked":
			play_punch_low_anim();
		"weekend-1-punchlowdodged":
			play_punch_low_anim();
		"weekend-1-punchlowspin":
			play_punch_low_anim();

		"weekend-1-punchhigh":
			play_punch_high_anim();
		"weekend-1-punchhighblocked":
			play_punch_high_anim();
		"weekend-1-punchhighdodged":
			play_punch_high_anim();
		"weekend-1-punchhighspin":
			play_punch_high_anim();

		"weekend-1-blockhigh":
			play_block_anim();
		"weekend-1-blocklow":
			play_block_anim();
		"weekend-1-blockspin":
			play_block_anim();

		"weekend-1-dodgehigh":
			play_dodge_anim();
		"weekend-1-dodgelow":
			play_dodge_anim();
		"weekend-1-dodgespin":
			play_dodge_anim();

		# Pico ALWAYS gets punched.
		"weekend-1-hithigh":
			play_hit_high_anim();
		"weekend-1-hitlow":
			play_hit_low_anim();
		"weekend-1-hitspin":
			play_hit_spin_anim();

		"weekend-1-picouppercutprep":
			play_uppercut_prep_anim();
		"weekend-1-picouppercut":
			play_uppercut_anim(true);

		"weekend-1-darnelluppercutprep":
			play_idle_anim();
		"weekend-1-darnelluppercut":
			play_uppercut_hit_anim();

		"weekend-1-idle":
			play_idle_anim();
		"weekend-1-fakeout":
			play_fakeout_anim();
		"weekend-1-taunt":
			play_taunt_anim();
		"weekend-1-tauntforce":
			play_taunt_anim();
		"weekend-1-reversefakeout":
			play_idle_anim(); # TODO: Which anim?

func on_player_miss(note:Note):
	match note.note_type:
		# Pico fails to punch, and instead gets hit!
		"weekend-1-punchlow":
			play_hit_low_anim();
		"weekend-1-punchlowblocked":
			play_hit_low_anim();
		"weekend-1-punchlowdodged":
			play_hit_low_anim();
		"weekend-1-punchlowspin":
			play_hit_spin_anim();

		# Pico fails to punch, and instead gets hit!
		"weekend-1-punchhigh":
			play_hit_high_anim();
		"weekend-1-punchhighblocked":
			play_hit_high_anim();
		"weekend-1-punchhighdodged":
			play_hit_high_anim();
		"weekend-1-punchhighspin":
			play_hit_spin_anim();

		# Pico fails to block, and instead gets hit!
		"weekend-1-blockhigh":
			play_hit_high_anim();
		"weekend-1-blocklow":
			play_hit_low_anim();
		"weekend-1-blockspin":
			play_hit_spin_anim();

		# Pico fails to dodge, and instead gets hit!
		"weekend-1-dodgehigh":
				play_hit_high_anim();
		"weekend-1-dodgelow":
			play_hit_low_anim();
		"weekend-1-dodgespin":
				play_hit_spin_anim();

		# Pico ALWAYS gets punched.
		"weekend-1-hithigh":
			play_hit_high_anim();
		"weekend-1-hitlow":
			play_hit_low_anim();
		"weekend-1-hitspin":
			play_hit_spin_anim();

		# Fail to dodge the uppercut.
		"weekend-1-picouppercutprep":
			play_punch_high_anim();
			cant_uppercut = true;
		"weekend-1-picouppercut":
			play_uppercut_anim(false);

		# Darnell's attempt to uppercut, Pico dodges or gets hit.
		"weekend-1-darnelluppercutprep":
			play_idle_anim();
		"weekend-1-darnelluppercut":
			play_uppercut_hit_anim();

		"weekend-1-idle":
			play_idle_anim();
		"weekend-1-fakeout":
			play_hit_high_anim();
		"weekend-1-taunt":
			play_taunt_anim();
		"weekend-1-tauntforce":
			play_taunt_anim();
		"weekend-1-reversefakeout":
			play_idle_anim()

var alternate:bool = false

func do_alternate():
	alternate = !alternate
	return str(int(alternate) + 1)

func play_dodge_anim():
	player.play_anim("dodge", true, true)
	move_to_back()

func play_block_anim():
	player.play_anim("block", true, true)
	move_to_back()

func play_idle_anim():
	player.play_anim("idle", true, true)
	move_to_back()

func play_fakeout_anim():
	player.play_anim("fakeout", true, true)
	move_to_back()

func play_uppercut_prep_anim():
	player.play_anim("uppercutPrep", true, true)
	move_to_front()

func play_uppercut_hit_anim():
	player.play_anim("uppercutHit", true, true)
	move_to_back()

func play_uppercut_anim(hit:bool):
	player.play_anim("uppercut", true, true)
	move_to_front()

func play_hit_high_anim():
	player.play_anim("hitHigh", true, true)
	move_to_back()

func play_hit_low_anim():
	player.play_anim("hitLow", true, true)
	move_to_back()

func play_hit_spin_anim():
	player.play_anim("hitSpin", true, true)
	move_to_back()

func play_punch_high_anim():
	player.play_anim("punchHigh " + do_alternate(), true, true)
	move_to_front()

func play_punch_low_anim():
	player.play_anim("punchLow " + do_alternate(), true, true)
	move_to_front()

func play_taunt_anim():
	player.play_anim("taunt", true, true)
	move_to_back()

func play_taunt_conditional_anim():
	if player.anim_player.current_animation == "fakout":
		play_taunt_anim()
	else:
		play_idle_anim()
