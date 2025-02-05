extends MusicBeatScene

@export var trophies:Array[TrophyItem]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("note_down"):
		$CenterRef/ScrollContainer/HBoxContainer/Trophy.start_unlock()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")
		Global.switch_scene("res://scenes/MainMenu.tscn")
