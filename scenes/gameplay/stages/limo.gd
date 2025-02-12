extends Stage
@onready var dancey_group = $PL2/limo/dancey_group

func _ready():
	$PL2/limo.play("background limo pink")
	$PL3/limo.play("Limo stage")

func on_countdown_tick(a,b):
	for dancey_boy in dancey_group.get_children():
		dancey_boy.dance(0)
