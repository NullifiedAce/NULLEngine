extends Stage

@onready var philly_cars: AnimatedSprite2D = $'0-9 1-0/phillyCars'
@onready var philly_cars_2: AnimatedSprite2D = $'0-9 1-0/phillyCars2'
@onready var car_1: PathFollow2D = $Markers/carPath1/car1
@onready var car_2: PathFollow2D = $Markers/carPath2/car2
@onready var philly_traffic: AnimatedSprite2D = $'0-9 1-0/phillyTraffic'
@onready var rain_rect: ColorRect = $Rain/Rain

@export var intensity: float = 1.0
@export var rain_scale: float = 1.0
@export_color_no_alpha var rain_color: Color = Color(0.2, 0.3, 0.4)

var time: float = 0.0
var rain_start_intensity:float = 1.0
var rain_end_intensity:float = 1.0

var lights_stop:bool = false # state of the traffic lights
var last_change:int = 0
var change_interval:int = 8 # make sure it doesnt change until AT LEAST this many beats

var car_waiting:bool = false # if the car is waiting at the lights and is ready to go on green
var car_interruptable:bool = true # if the car can be reset
var car2_interruptable:bool = true

var global_delta:float

func _ready_post():
	if game.METADATA["rawSongName"] == "darnell":
		rain_start_intensity = 0.0
		rain_end_intensity = 0.1
	elif game.METADATA["rawSongName"] == "lit up":
		rain_start_intensity = 0.1
		rain_end_intensity = 0.2
	elif game.METADATA["rawSongName"] == "2hot":
		rain_start_intensity = 0.2
		rain_end_intensity = 0.4

	intensity = rain_start_intensity
	reset_cars(true, true)
	reset_stage_values()

func _process(delta: float) -> void:
	global_delta = delta

	var remapped_intensity_value:float = clamp(remap(Conductor.position, 0, Audio.music.stream.get_length() * 1000, rain_start_intensity, rain_end_intensity), rain_start_intensity, rain_end_intensity)
	intensity = remapped_intensity_value
	time += delta
	rain_rect.material.set_shader_parameter("uTime", time)
	rain_rect.material.set_shader_parameter("uIntensity", intensity)
	rain_rect.material.set_shader_parameter("uScale", rain_scale)
	rain_rect.material.set_shader_parameter("uRainColor", rain_color)

# Resets every value of a car and hides it from view.
func reset_cars(left:bool, right:bool):
	if left:
		car_waiting = false
		car_interruptable = true
		car_1.progress_ratio = 1
	if right:
		car2_interruptable = true
		car_2.progress_ratio = 1

func reset_stage_values():
	last_change = 0
	change_interval = 8
	philly_traffic.play("redtogreen")
	lights_stop = false

# Changes the current state of the traffic lights.
# Updates the next change accordingly and will force cars to move when ready
func change_lights(beat:int):
	last_change = beat
	lights_stop = !lights_stop

	if lights_stop:
		philly_traffic.play("greentored")
		change_interval = 20
	else:
		philly_traffic.play("redtogreen")
		change_interval = 30
		if car_waiting: finish_car_lights(car_1)

func finish_car_lights(sprite:PathFollow2D):
	car_waiting = false
	var duration:float = Global.rng.randf_range(1.8, 3)
	var start_delay:float = Global.rng.randf_range(0.2, 1.2)

	sprite.progress_ratio = 0.175
	var t:Tween = create_tween()
	t.tween_property(sprite, "progress_ratio", 1, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).set_delay(start_delay)
	t.finished.connect(func(): car_interruptable = true)

func drive_car_lights(sprite:PathFollow2D):
	car_interruptable = false
	var variant:int = Global.rng.randi_range(1, 4)
	philly_cars.play("car" + str(variant))
	var extra_offset = Vector2(0, 0)
	var duration:float = 2

	match variant:
		1:
			duration = Global.rng.randf_range(1, 1.7)
		2:
			duration = Global.rng.randf_range(0.9, 1.5)
			extra_offset = Vector2(20, -15)
		3:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(30, 50)
		4:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(10, 60)

	sprite.progress_ratio = 0
	var t:Tween = create_tween()
	t.tween_property(sprite, "progress_ratio", 0.175, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.finished.connect(func():
		car_waiting = true
		if !lights_stop: finish_car_lights(car_1))

# Drives a car across the screen without stopping.
# Used when the lights are green.
func drive_car(sprite:PathFollow2D):
	car_interruptable = false
	var variant:int = Global.rng.randi_range(1, 4)
	philly_cars.play("car" + str(variant))
	var extra_offset = Vector2(0, 0)
	var duration:float = 2

	match variant:
		1:
			duration = Global.rng.randf_range(1, 1.7)
		2:
			duration = Global.rng.randf_range(0.6, 1.2)
			extra_offset = Vector2(20, -15)
		3:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(30, 50)
		4:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(10, 60)

	sprite.progress_ratio = 0.0
	var t:Tween = create_tween()
	t.tween_property(sprite, "progress_ratio", 1, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.finished.connect(func(): car_interruptable = true)

func drive_car2(sprite:PathFollow2D):
	car2_interruptable = false
	var variant:int = Global.rng.randi_range(1, 4)
	philly_cars.play("car" + str(variant))
	var extra_offset = Vector2(0, 0)
	var duration:float = 2

	match variant:
		1:
			duration = Global.rng.randf_range(1, 1.7)
		2:
			duration = Global.rng.randf_range(0.6, 1.2)
			extra_offset = Vector2(20, -15)
		3:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(30, 50)
		4:
			duration = Global.rng.randf_range(1.5, 2.5)
			extra_offset = Vector2(10, 60)

	sprite.progress_ratio = 1.0
	var t:Tween = create_tween()
	t.tween_property(sprite, "progress_ratio", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	t.finished.connect(func(): car2_interruptable = true)

func on_beat_hit(beat:int):
	if Global.rng.randi_range(0, 100) <= 10 and beat != (last_change + change_interval) and car_interruptable:
		if !lights_stop:
			drive_car(car_1)
		else:
			drive_car_lights(car_1)

	if Global.rng.randi_range(0, 100) <= 10 and beat != (last_change + change_interval) and car2_interruptable and !lights_stop: drive_car2(car_2)

	if beat == (last_change + change_interval): change_lights(beat)
