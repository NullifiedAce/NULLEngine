extends Node2D

func _ready() -> void:
	ModManager._ready()
	ModManager.switch_mod(SettingsAPI.get_setting("current mod"))
	if SettingsAPI.get_setting("first launch") == true and ProjectSettings.get_setting("engine/customization/first_launch_menu"):
		get_tree().change_scene_to_file("res://scenes/first_launch.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
