extends MusicBeatScene

var pressed = false
var hide = false

var OPPONENT_HEALTH_COLOR:StyleBoxFlat = preload("res://assets/styles/healthbar/opponent.tres")
var PLAYER_HEALTH_COLOR:StyleBoxFlat = preload("res://assets/styles/healthbar/player.tres")

func _ready() -> void:
	super._ready()
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)

	RichPresence.set_text("In the menus", "HUD Editor")

func _process(_delta: float) -> void:
	#FPS.visible = false

	$BG.modulate = Color.from_string(SettingsAPI.get_setting("bg color"), Color.WHITE)

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
