extends MusicBeatScene

var pressed = false
var hide = false

func _ready() -> void:
	super._ready()
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)

	RichPresence.set_text("In the menus", "HUD Editor")

func _process(_delta: float) -> void:
	FPS.visible = false

	if Input.is_key_label_pressed(KEY_ESCAPE) and !pressed:
		Audio.play_sound("cancelMenu")
		pressed = true
		Global.switch_scene("res://scenes/OptionsMenu.tscn")
		FPS.visible = true
	if Input.is_action_just_pressed("hud_hide"):
		if !hide:
			hide = true
			$TabContainer/hide.play('hidden')
		else:
			hide = false
			$TabContainer/hide.play_backwards('hidden')


var rng = RandomNumberGenerator.new()

func beat_hit(beat:int):
	var value1 = rng.randi_range(0, 255)
	var value2 = rng.randi_range(0, 255)
	var value3 = rng.randi_range(0, 255)

	$BG.modulate = Color8(value1, value2, value3, 255)
