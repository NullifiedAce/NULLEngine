extends Stage

@onready var lightgreen: PointLight2D = $PB/PL1/lightgreen
@onready var lightred: PointLight2D = $PB/PL1/lightred

func _ready_post():
	$PL3/crowd.play()
