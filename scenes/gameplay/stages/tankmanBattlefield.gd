extends Stage

@onready var tank_ground: AnimatedSprite2D = $'0-5/tank_ground'

@onready var boppers:Array = [
	$'0-5/tank_watch_tower',
	$'1-5/tank2',
	$'1-5/tank4',
	$'1-5/tank5',
	$'3-5 2-5/tank3',
	$'2-0 0-2/bopper2',
	$'1-7 1-5/tank0'
]

var tank_angle:float = randi_range(-90, 45)
var tank_speed:float = randf_range(5, 7)
const TANK_X:float = 400

func _ready():
	Conductor.beat_hit.connect(beat_hit)
	$'0-4/smoke_right'.play("SmokeRight instance 1")
	$'0-4/smoke_left'.play("SmokeBlurLeft instance 1")

func _process(delta: float) -> void:
	tank_angle += delta * tank_speed
	tank_ground.rotation_degrees = tank_angle - 90 + 15
	tank_ground.position = Vector2(TANK_X + cos(deg_to_rad(tank_angle + 180)) * 1500,
			1300 + sin(deg_to_rad(tank_angle + 180)) * 1100)

func beat_hit(beat:int):
	for bopper in boppers:
		bopper.play("bop")
