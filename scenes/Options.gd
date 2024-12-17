extends MusicBeatScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)
	Conductor.position = 0.0

	if not OS.is_debug_build():
		$Tools.queue_free() # Automatically remove the tools button, because it serves no purpose in exported builds.

	Ranking.judgements = Ranking.default_judgements.duplicate(true)
	Ranking.ranks = Ranking.default_ranks.duplicate(true)
	RichPresence.set_text("In the menus", "Configuring Options")

func _process(delta: float) -> void:
	Conductor.position += delta * 1000.0

	var scroll_speed:float = 1.0 if SettingsAPI.get_setting("scroll speed") <= 0 else SettingsAPI.get_setting("scroll speed")

	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")

		var exit_scene_path:String = Global.scene_arguments["options_menu"].exit_scene_path

		if len(exit_scene_path) > 0:
			Global.switch_scene(exit_scene_path)
		else:
			Global.switch_scene("res://scenes/MainMenu.tscn")


func _on_hud_editor_pressed() -> void:
	Global.switch_scene("res://scenes/HUDEditor.tscn")
