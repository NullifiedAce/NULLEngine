extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")
		Global.switch_scene("res://scenes/OptionsMenu.tscn")
