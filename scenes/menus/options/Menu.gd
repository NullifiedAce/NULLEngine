extends MusicBeatScene

var cur_tab:int = 0
var tools_open: bool = false
var strum_editor_open:bool = false

@onready var bg: Panel = $OptionPlacement/BG
@onready var switch: AnimationPlayer = $switch
@onready var strum_editor: Node2D = $StrumEditor

func _ready() -> void:
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)
	Conductor.position = 0.0

	if not OS.is_debug_build():
		$Tools.queue_free() # Automatically remove the tools button, because it serves no purpose in exported builds.

	Ranking.judgements = Ranking.default_judgements.duplicate(true)
	Ranking.ranks = Ranking.default_ranks.duplicate(true)
	RichPresence.set_text("In the menus", "Configuring Options")

	update_tabs(cur_tab)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")

		var exit_scene_path:String = Global.scene_arguments["options_menu"].exit_scene_path

		if len(exit_scene_path) > 0:
			Global.switch_scene(exit_scene_path)
		else:
			Global.switch_scene("res://scenes/menus/main menu/Menu.tscn")

func _on_tab_pressed(extra_arg_0: int) -> void:
	Audio.play_sound("scrollMenu")

	cur_tab = extra_arg_0
	update_tabs(cur_tab)

func update_tabs(selection:int):
	for i in bg.get_children():
		i.hide()
		if i == bg.get_child(cur_tab): i.show()

func _on_hud_editor_pressed() -> void:
	Global.switch_scene("res://scenes/HUDEditor.tscn")

func _on_strum_editor_pressed() -> void:
	strum_editor_open = true
	switch.play("ToStrum")

func _on_tools_pressed() -> void:
	if !tools_open:
		tools_open = true
		switch.play("SwitchTools")
	else:
		tools_open = false
		switch.play_backwards("SwitchTools")
