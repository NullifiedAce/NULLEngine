extends Stage

@onready var sniper: AnimatedSprite2D = $sniper
@onready var guy: AnimatedSprite2D = $guy

func on_beat_hit(beat:int):
	if beat % 2 == 0:
		sniper.play("idle")
		guy.play("idle")
