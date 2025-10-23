extends CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("screenshot"):
		if !DirAccess.dir_exists_absolute("user://screenshots/"):
			DirAccess.make_dir_absolute("user://screenshots/")

		var capture = get_viewport().get_texture().get_image()
		var _time = Time.get_datetime_string_from_system().replace(":", "-")
		var filename = "user://screenshots/screenshot_" + _time + ".png"

		Audio.play_sound("screenshot")

		capture.save_png(filename)
