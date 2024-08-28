extends Node2D

var page: int = 0

func _ready() -> void:
	Audio.play_music("freakyMenu")
	$FG/Title.play('selected')

	RichPresence.set_text("In the menus", "Credits Menu")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")
		Global.switch_scene("res://scenes/MainMenu.tscn")
	if Input.is_action_pressed("ui_down"):
		$ScrollContainer.scroll_vertical = $ScrollContainer.scroll_vertical + 8
	if Input.is_action_pressed("ui_up"):
		$ScrollContainer.scroll_vertical = $ScrollContainer.scroll_vertical - 8
