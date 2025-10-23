extends Stage

@onready var rain_rect: ColorRect = $Rain/Rain
@onready var sky_blur: Sprite2D = $sky/skyBlur
@onready var sky_additive: Sprite2D = $'0-0/skyAdditive'
@onready var lightning: AnimatedSprite2D = $'0-0/lightning'
@onready var foreground_multiply: Sprite2D = $'0-0/foregroundMultiply'
@onready var additional_lighten: ColorRect = $'0-0/additionalLighten'


@export var intensity: float = 1.0
@export var rain_scale: float = 1.0
@export var rain_color: Color = Color(0.2, 0.3, 0.4)

var time: float = 0.0
var rain_time_scale: float = 1.0

var camera_initialized:bool = false
var camera_darkened:bool = false

var lightning_timer:float = 3.0
var lightning_active:bool = true

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

var global_delta:float

func _process(delta: float) -> void:
	global_delta = delta
	time += delta * rain_time_scale
	rain_rect.material.set_shader_parameter("uTime", time)
	rain_rect.material.set_shader_parameter("uIntensity", intensity)
	rain_rect.material.set_shader_parameter("uScale", rain_scale)
	rain_rect.material.set_shader_parameter("uRainColor", rain_color)
	rain_time_scale = lerpf(rain_time_scale, 0.02, 0.05)

	if !camera_initialized:
		camera_initialized = true

		game.player.modulate = Color.from_string("DEDEDEFF", Color.WHITE)
		game.opponent.modulate = Color.from_string("DEDEDEFF", Color.WHITE)
		game.spectator.modulate = Color.from_string("888888FF", Color.WHITE)

	if lightning_active:
		lightning_timer -= delta
	else:
		lightning_timer = 1

	if lightning_timer <= 0:
		apply_lightning()
		lightning_timer = rng.randf_range(7, 15)

func apply_lightning() -> void:
	var LIGHTNING_FULL_DURATION = 1.5
	var LIGHTNING_FADE_DURATION = 0.3

	sky_additive.show()
	sky_additive.modulate = Color(1, 1, 1, 0.7)
	var t:Tween = create_tween()
	t.tween_property(sky_additive, "modulate:a", 0.0, LIGHTNING_FULL_DURATION)
	t.finished.connect(cleanup_lightning)

	foreground_multiply.show()
	foreground_multiply.material.set_shader_parameter("alpha", 0.64)
	$'0-0/AnimationPlayer'.speed_scale = 1.0 / LIGHTNING_FULL_DURATION
	$'0-0/AnimationPlayer'.play("strike")

	additional_lighten.show()
	additional_lighten.modulate = Color(1, 1, 1, 0.64)
	var t3:Tween = create_tween()
	t3.tween_property(additional_lighten, "modulate:a", 0.0, LIGHTNING_FULL_DURATION)

	lightning.show()
	lightning.play("lightning")

	if rng.randi_range(0, 100) <= 65:
		lightning.position.x = rng.randi_range(-250, 280)
	else:
		lightning.position.x = rng.randi_range(780, 900)

	game.player.modulate = Color.from_string("606060FF", Color.WHITE)
	var t4:Tween = create_tween()
	t4.tween_property(game.player, "modulate", Color.from_string("DEDEDEFF", Color.WHITE), LIGHTNING_FADE_DURATION)
	game.opponent.modulate = Color.from_string("606060FF", Color.WHITE)
	var t5:Tween = create_tween()
	t5.tween_property(game.opponent, "modulate", Color.from_string("DEDEDEFF", Color.WHITE), LIGHTNING_FADE_DURATION)
	game.spectator.modulate = Color.from_string("606060FF", Color.WHITE)
	var t6:Tween = create_tween()
	t6.tween_property(game.spectator, "modulate", Color.from_string("888888FF", Color.WHITE), LIGHTNING_FADE_DURATION)

	$LightningSounds.get_child(rng.randi_range(0, 2)).play()

func cleanup_lightning():
	sky_additive.hide()
	foreground_multiply.hide()
	additional_lighten.hide()
	lightning.hide()
