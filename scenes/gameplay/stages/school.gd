extends Stage

func _ready():
	$'0-85/trees'.play("trees")
	$'0-85/petals'.play("PETALS ALL")

	$'0-9/AnimatedSprite2D'.play("BG girls group")
	if Global.METADATA.songName.to_lower() == "roses":
		$'0-9/AnimatedSprite2D'.play("BG fangirls dissuaded")
