extends Stage
@onready var dancey_group = $PL2/limo/dancey_group

@export var back_limo:AnimatedSprite2D
@export var back_limo_anim:String
@export var limo:AnimatedSprite2D
@export var limo_anim:String

func _ready():
	back_limo.play(back_limo_anim)
	limo.play(limo_anim)

func on_countdown_tick(a,b):
	for dancey_boy in dancey_group.get_children():
		dancey_boy.dance(0)
