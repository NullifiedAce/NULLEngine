extends Button

func _on_pressed() -> void:
	$save.show()

func _on_save(path: String) -> void:
	var cfg_file = ConfigFile.new()

	for i in Global.hud_options:
		cfg_file.set_value("Preset", i, SettingsAPI.get_setting(i))

		cfg_file.save(path)
	print("Save preset to " + path)
