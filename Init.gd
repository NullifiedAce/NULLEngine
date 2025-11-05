extends Node2D

func _ready() -> void:
	ModManager._ready()
	ModManager.switch_mod(OptionsAPI.get_option("current mod"))
	if OptionsAPI.get_option("first launch") == true and ProjectSettings.get_setting("engine/customization/first_launch_menu"):
		get_tree().change_scene_to_file("res://scenes/menus/first launch/Menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/menus/title/Menu.tscn")
