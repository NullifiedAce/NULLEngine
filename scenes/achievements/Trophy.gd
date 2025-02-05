@tool
extends Control
class_name FunkinTrophy


@export_group("Trophy")
## Which kind of trophy should be displayed.
@export_enum("Bronze", "Silver", "Gold", "Platinum") var trophy:int = 0
## If checked, the trophy will emit sparkle particles.
@export var particles_emitting:bool = false
## Amount of particles should be displayed. (Will only update once the trophy is reloaded.)
@export var particles_amount:float = 8
## If the trophy whether should be locked or not
@export var locked:bool = false
@export_group("Trophy Data")
@export var trophy_title:String = "Play the game."
@export_multiline var trophy_description:String = "Start the game."

@onready var sprite: Sprite2D = $Sprite
@onready var title: Label = $title
@onready var particles: CPUParticles2D = $Particles
@onready var animation: AnimationPlayer = $Animation

func _ready() -> void:
	particles.amount = particles_amount
	title.text = trophy_title

func _process(delta: float) -> void:
	sprite.frame = trophy

	if locked:
		modulate = Color.BLACK
		particles.emitting = false
		title.hide()
	else:
		modulate = Color.WHITE
		particles.emitting = particles_emitting
		title.show()

func start_unlock():
	animation.play("unlock")

func unlock():
	locked = false
