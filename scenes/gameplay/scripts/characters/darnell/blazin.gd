extends FunkinScript

var cant_uppercut:bool = false

var opponent

func _ready_post() -> void:
	opponent = game.opponent

	opponent.play_anim("idle")

	opponent.anim_player.speed_scale = 1.1

func move_to_back():
	opponent.z_index = 2000

func move_to_front():
	opponent.z_index = 3000

func on_note_hit(note:Note):
	print("darnell do something bruh")
	
	match note.note_type:
		"weekend-1-punchlow":
			play_hit_low_anim();
		"weekend-1-punchlowblocked":
			play_block_anim();
		"weekend-1-punchlowdodged":
			play_dodge_anim();
		"weekend-1-punchlowspin":
			play_hit_spin_anim();

		"weekend-1-punchhigh":
			play_hit_high_anim();
		"weekend-1-punchhighblocked":
			play_block_anim();
		"weekend-1-punchhighdodged":
			play_dodge_anim();
		"weekend-1-punchhighspin":
			play_hit_spin_anim();

		"weekend-1-blockhigh":
			play_punch_high_anim();
		"weekend-1-blocklow":
			play_punch_low_anim();
		"weekend-1-blockspin":
			play_punch_high_anim();

		"weekend-1-dodgehigh":
			play_punch_high_anim();
		"weekend-1-dodgelow":
			play_punch_low_anim();
		"weekend-1-dodgespin":
			play_punch_high_anim();

		# Attempt to punch, Pico ALWAYS gets hit.
		"weekend-1-hithigh":
			play_punch_high_anim();
		"weekend-1-hitlow":
			play_punch_low_anim();
		"weekend-1-hitspin":
			play_punch_high_anim();

		"weekend-1-picouppercutprep":
			pass
		"weekend-1-picouppercut":
			play_uppercut_hit_anim()

		"weekend-1-darnelluppercutprep":
			play_uppercut_prep_anim();
		"weekend-1-darnelluppercut":
			play_uppercut_anim();

		"weekend-1-idle":
			play_idle_anim();
		"weekend-1-fakeout":
			play_cringe_anim();
		"weekend-1-taunt":
			play_taunt_conditional_anim();
		"weekend-1-tauntforce":
			play_pissed_anim();
		"weekend-1-reversefakeout":
			play_fakeout_anim(); # TODO: Which anim?

func on_player_miss(note:Note):
	match note.note_type:
		# Pico tried and failed to punch, punch back!
		"weekend-1-punchlow":
			play_punch_low_anim();
		"weekend-1-punchlowblocked":
			play_punch_low_anim();
		"weekend-1-punchlowdodged":
			play_punch_low_anim();
		"weekend-1-punchlowspin":
			play_punch_low_anim();

		# Pico tried and failed to punch, punch back!
		"weekend-1-punchhigh":
			play_punch_high_anim();
		"weekend-1-punchhighblocked":
			play_punch_high_anim();
		"weekend-1-punchhighdodged":
			play_punch_high_anim();
		"weekend-1-punchhighspin":
			play_punch_high_anim();

		# Attempt to punch, Pico dodges or gets hit.
		"weekend-1-blockhigh":
			play_punch_high_anim();
		"weekend-1-blocklow":
			play_punch_low_anim();
		"weekend-1-blockspin":
			play_punch_high_anim();

		# Attempt to punch, Pico dodges or gets hit.
		"weekend-1-dodgehigh":
			play_punch_high_anim();
		"weekend-1-dodgelow":
			play_punch_low_anim();
		"weekend-1-dodgespin":
			play_punch_high_anim();

		# Attempt to punch, Pico ALWAYS gets punched.
		"weekend-1-hithigh":
			play_punch_high_anim();
		"weekend-1-hitlow":
			play_punch_low_anim();
		"weekend-1-hitspin":
			play_punch_high_anim();

		# Succesfully dodge the uppercut.
		"weekend-1-picouppercutprep":
			play_hit_high_anim();
			cant_uppercut = true;
		"weekend-1-picouppercut":
			play_dodge_anim();

		# Darnell's attempt to uppercut, Pico dodges or gets hit.
		"weekend-1-darnelluppercutprep":
			play_uppercut_prep_anim();
		"weekend-1-darnelluppercut":
			play_uppercut_anim();

		"weekend-1-idle":
			play_idle_anim();
		"weekend-1-fakeout":
			play_cringe_anim(); # TODO: Which anim?
		"weekend-1-taunt":
			play_pissed_anim();
		"weekend-1-tauntforce":
			play_pissed_anim();
		"weekend-1-reversefakeout":
			play_fakeout_anim()

var alternate:bool = false

func do_alternate():
	alternate = !alternate
	return str(int(alternate) + 1)

func play_dodge_anim():
	opponent.play_anim("dodge", true, true)
	move_to_back()

func play_block_anim():
	opponent.play_anim("block", true, true)
	move_to_back()

func play_idle_anim():
	opponent.play_anim("idle", true, true)
	move_to_back()

func play_fakeout_anim():
	opponent.play_anim("fakeout", true, true)
	move_to_back()

func play_uppercut_prep_anim():
	opponent.play_anim("uppercutPrep", true, true)
	move_to_front()

func play_uppercut_hit_anim():
	opponent.play_anim("uppercutHit", true, true)
	move_to_back()

func play_uppercut_anim():
	opponent.play_anim("uppercut", true, true)
	move_to_front()

func play_hit_high_anim():
	opponent.play_anim("hitHigh", true, true)
	move_to_back()

func play_hit_low_anim():
	opponent.play_anim("hitLow", true, true)
	move_to_back()

func play_hit_spin_anim():
	opponent.play_anim("hitSpin", true, true)
	move_to_back()

func play_punch_high_anim():
	opponent.play_anim("punchHigh " + do_alternate(), true, true)
	move_to_front()

func play_punch_low_anim():
	opponent.play_anim("punchLow " + do_alternate(), true, true)
	move_to_front()

func play_taunt_anim():
	opponent.play_anim("taunt", true, true)
	move_to_back()

func play_taunt_conditional_anim():
	if opponent.anim_player.current_animation == "fakout":
		play_taunt_anim()
	else:
		play_idle_anim()

func play_cringe_anim():
	opponent.play_anim("cringe", true, true)
	move_to_back()

func play_pissed_anim():
	opponent.play_anim("pissed", true, true)
	move_to_back()
