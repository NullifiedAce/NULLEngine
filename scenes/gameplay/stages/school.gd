extends Stage
func _ready():
	$PB/PL6/AnimatedSprite2D.play("BG girls group")
	if Global.METADATA.songName.to_lower() == "roses":
		$PB/PL6/AnimatedSprite2D.play("BG fangirls dissuaded")
