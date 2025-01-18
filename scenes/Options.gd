extends MusicBeatScene

var tools_open: bool = false
var strum_editor_open:bool = false

@onready var switch: AnimationPlayer = $switch
@onready var strum_editor: Node2D = $StrumEditor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !strum_editor_open:
		strum_editor.hide()

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

func _on_tool_button_pressed(name:String):
	match name:
		"XML Converter":
			Global.switch_scene("res://tools/XML Converter.tscn")
		"TXT Converter":
			Global.switch_scene("res://tools/TXT Converter.tscn")
		"Adobe Json Converter":
			Global.switch_scene("res://tools/Adobe Json Converter.tscn")

func _on_tools_pressed() -> void:
	tools_open = not tools_open
	if tools_open:
		switch.play('switch')
	else:
		switch.play_backwards('switch')

func _on_open_strum_editor() -> void:
	strum_editor_open = true
	$StrumEditor.show()
	switch.play('strumEditor')
	await switch.animation_finished
	$TabContainer.hide()
