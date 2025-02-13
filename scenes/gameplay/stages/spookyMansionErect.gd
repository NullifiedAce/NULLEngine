extends Stage

@onready var rain: ColorRect = $'0-8/rain'

@onready var bg_light: Sprite2D = $'1-1/bgLight'
@onready var stairs_light: Sprite2D = $'1-1/stairsLight'
@onready var sounds: Node = $Sounds

@export var intensity: float = 1.0
@export var rain_scale: float = 1.0
@export_color_no_alpha var rain_color: Color = Color(0.2, 0.3, 0.4)

var lightning_strike_beat:int = 0
var lightning_strike_offset:int = 8

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	rain.material.set_shader_parameter("uTime", time)
	rain.material.set_shader_parameter("uIntensity", intensity)
	rain.material.set_shader_parameter("uScale", rain_scale)
	rain.material.set_shader_parameter("uRainColor", rain_color)

func do_lightning_stike(play_sound:bool, beat:int):
	if play_sound: sounds.get_child(Global.rng.randi_range(0, 1)).play()

	bg_light.modulate.a = 1.0
	stairs_light.modulate.a = 1.0
	game.player.anim_sprite.modulate.a = 0.0
	game.opponent.anim_sprite.modulate.a = 0.0
	game.spectator.anim_sprite.modulate.a = 0.0

	get_tree().create_timer(0.06).timeout.connect(func():
		bg_light.modulate.a = 0.0
		stairs_light.modulate.a = 0.0
		game.player.anim_sprite.modulate.a = 1.0
		game.opponent.anim_sprite.modulate.a = 1.0
		game.spectator.anim_sprite.modulate.a = 1.0
		)

	get_tree().create_timer(0.12).timeout.connect(func():
		var t1:Tween = create_tween()
		var t2:Tween = create_tween()
		var t3:Tween = create_tween()
		var t4:Tween = create_tween()
		var t5:Tween = create_tween()

		bg_light.modulate.a = 1.0
		stairs_light.modulate.a = 1.0
		game.player.anim_sprite.modulate.a = 0.0
		game.opponent.anim_sprite.modulate.a = 0.0
		game.spectator.anim_sprite.modulate.a = 0.0

		t1.tween_property(bg_light, "modulate:a", 0.0, 1.5)
		t2.tween_property(stairs_light, "modulate:a", 0.0, 1.5)
		t3.tween_property(game.player.anim_sprite, "modulate:a", 1.0, 1.5)
		t4.tween_property(game.opponent.anim_sprite, "modulate:a", 1.0, 1.5)
		t5.tween_property(game.spectator.anim_sprite, "modulate:a", 1.0, 1.5)
		)

	lightning_strike_beat = beat
	lightning_strike_offset = Global.rng.randi_range(8, 24)

	game.player.play_anim("scared", true)
	game.spectator.play_anim("scared", true)

func on_beat_hit(beat:int):
	if beat == 4 and game.METADATA["rawSongName"] == "spookeez": do_lightning_stike(false, beat)

	if Global.rng.randi_range(1, 100) <= 10 and beat > (lightning_strike_beat + lightning_strike_offset):
		do_lightning_stike(true, beat)
