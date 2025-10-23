extends Stage

@onready var da_boppers = [$PL2/UpperBop, $PL5/BottomBop, $PL6/Santa]

func on_beat_hit(beat:int):
	for bopper in da_boppers:
		bopper.anim_player.seek(0.0)
		bopper.frame = 0
		bopper.anim_player.play("bop")
