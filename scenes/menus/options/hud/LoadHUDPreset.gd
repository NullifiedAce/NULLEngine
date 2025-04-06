extends Button

func _on_pressed() -> void:
	$load.show()

func _on_load(path: String) -> void:
	var cfg_file = ConfigFile.new()

	var err = cfg_file.load(path)
	if err != OK:
		return

	Global.update_options = false
	for i in Global.hud_options:
		print(i + ": " + str(cfg_file.get_value("Preset", i)))
		SettingsAPI.set_setting(i, cfg_file.get_value("Preset", i))
	print("Loaded preset.")
	await get_tree().create_timer(0.5).timeout
	Global.update_options = true
