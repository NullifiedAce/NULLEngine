extends FunkinScript

var cocked:bool = false

@onready var can: AnimateSymbol = $can
@onready var can_anim: AnimationPlayer = $can/AnimationPlayer
@onready var explode: AnimatedSprite2D = $explode

func _ready() -> void:
	explode.animation_finished.connect(func():
		explode.hide()
	)

func on_note_hit(note:Note):
	match note.note_type:
		"weekend-1-kickcan":
			var canPile:Sprite2D
			for i in game.stage.get_children():
				if i.name == "spraycanPile": canPile = i
			
			can.position.x = canPile.position.x + 560
			can.position.y = canPile.position.y - 430
			can.z_index = canPile.z_index - 1
			can.show()
			can_anim.play("canStart")
		"weekend-1-cockgun":
			cocked = true
		"weekend-1-firegun":
			if cocked:
				can.position.x -= 340
				can_anim.play("canShoot")
				get_tree().create_timer(1 / 24).timeout.connect(func():
					darken_stage_props()
				)
			else:
				take_can_damage()

func darken_stage_props():
	game.stage.modulate = Color.from_string("111111", Color.WHITE)
	get_tree().create_timer(1 / 24).timeout.connect(func():
		game.stage.modulate = Color.from_string("222222", Color.WHITE)
		var t:Tween = create_tween()
		t.tween_property(game.stage, "modulate", Color.WHITE, 1.4)
	)

func on_player_miss(note:Note):
	if note.note_type == "weekend-1-cockgun":
		cocked = false

	if note.note_type == "weekend-1-firegun":
		game.player.play_anim("hit", true, true)
		take_can_damage()

const HEALTH_LOSS = 0.25 * 4

func take_can_damage():
	can.hide()
	explode.position = can.position + Vector2(500, 200)
	explode.show()
	explode.z_index = can.z_index
	explode.play("idle")
	game.health -= HEALTH_LOSS
