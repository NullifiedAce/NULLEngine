extends MusicBeatScene

var pressed = false
var hide = false

var OPPONENT_HEALTH_COLOR:StyleBoxFlat = preload("res://assets/styles/healthbar/opponent.tres")
var PLAYER_HEALTH_COLOR:StyleBoxFlat = preload("res://assets/styles/healthbar/player.tres")

@onready var score_text: Label = $HUD/HealthBar/ScoreText

func _ready() -> void:
	super._ready()
	if !ProjectSettings.get_setting("engine/customization/custom_score_text"):
		$'Editor/TabContainer/Score Text'.queue_free()
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)

	$BG.color = Color.from_string(SettingsAPI.get_setting("bg color"), Color.WHITE)
	if SettingsAPI.get_setting("custom color"):
		OPPONENT_HEALTH_COLOR.bg_color = Color.from_string(SettingsAPI.get_setting("opp color"), Color.WHITE)
		PLAYER_HEALTH_COLOR.bg_color = Color.from_string(SettingsAPI.get_setting("player color"), Color.WHITE)

	RichPresence.set_text("In the menus", "HUD Editor")

func _process(_delta: float) -> void:
	var score_values: Dictionary = {
		"score": 0,
		"misses": 0,
		"accuracy": 100,
		"ranks": SettingsAPI.get_setting("s+ rank"),
		"health": 50,
		"combo": 0,
		"max combo": 0,
		"ghost taps": 0
	}
	if Global.update_options:
		$BG.color = Color.from_string(SettingsAPI.get_setting("bg color"), Color.WHITE)
		if SettingsAPI.get_setting("custom color"):
			OPPONENT_HEALTH_COLOR.bg_color = Color.from_string(SettingsAPI.get_setting("opp color"), Color.WHITE)
			PLAYER_HEALTH_COLOR.bg_color = Color.from_string(SettingsAPI.get_setting("player color"), Color.WHITE)
		else:
			OPPONENT_HEALTH_COLOR.bg_color = Color(1, 0, 0, 1)
			PLAYER_HEALTH_COLOR.bg_color = Color(0, 1, 0, 1)

		var array = str_to_var(SettingsAPI.get_setting("score_arrangement"))
		var text_length = 0

		score_text.text = "" # Reset the score text to nothing.

		for i in array:
			text_length += 1
			if text_length == array.size():
				score_text.text += SettingsAPI.get_setting(i + " prefix") + str(score_values[i]) + SettingsAPI.get_setting(i + " suffix")
			else:
				score_text.text += SettingsAPI.get_setting(i + " prefix") + str(score_values[i]) + SettingsAPI.get_setting(i + " suffix") + SettingsAPI.get_setting("seperator")

		if Input.is_key_label_pressed(KEY_ESCAPE) and !pressed:
			Audio.play_sound("cancelMenu")
			pressed = true
			Global.switch_scene("res://scenes/OptionsMenu.tscn")
		if Input.is_action_just_pressed("hud_hide"):
			if !hide:
				hide = true
				$Editor/TabContainer/hide.play('hidden')
			else:
				hide = false
				$Editor/TabContainer/hide.play_backwards('hidden')

func _on_rearrange_counters_pressed() -> void:
	$Rearrange.show()

func _on_customize_pressed() -> void:
	$CustomizeCounter.show()
