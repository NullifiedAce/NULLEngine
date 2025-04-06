extends Control
class_name FunkinTrophy

@export var unlocked: bool = false

@export_group("Trophy")
## Which kind of trophy should be displayed.
@export_enum("Bronze", "Silver", "Gold", "Platinum") var trophy:int = 0
## If checked, the trophy will emit sparkle particles.
@export var particles_emitting:bool = false
## Amount of particles should be displayed. (Will only update once the trophy is reloaded.)
@export var particles_amount:float = 8
## If the trophy whether should be hidden or not
@export var trophy_hidden:bool = false
@export_group("Trophy Data")
@export var trophy_id:String = "FF"
@export var trophy_title:String = "Play the game."
@export_multiline var trophy_description:String = "Start the game."

@onready var sprite: Sprite2D = $Sprite
@onready var title: Label = $title
@onready var particles: CPUParticles2D = $Particles
@onready var animation: AnimationPlayer = $Animation

func _ready() -> void:
	title.text = trophy_title
	sprite.frame = trophy
	particles.amount = particles_amount

func _process(delta: float) -> void:
	if !unlocked:
		sprite.modulate = Color.BLACK
		particles.emitting = false
		if trophy_hidden:
			title.hide()
	else:
		sprite.modulate = Color.WHITE
		title.show()
		particles.emitting = particles_emitting


func start_unlock():
	animation.play("unlock")

func unlock():
	trophy_hidden = false
	unlocked = true
