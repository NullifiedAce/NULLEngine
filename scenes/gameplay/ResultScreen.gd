extends Node2D

@onready var result: AnimatedSprite2D = $BG/result
@onready var sound_system: AnimatedSprite2D = $BG/soundSystem
@onready var ratings: AnimatedSprite2D = $BG/ratings
@onready var score: AnimatedSprite2D = $BG/score
@onready var highscore: AnimatedSprite2D = $BG/highscore
@onready var gf: AnimatedSprite = $gf
@onready var bf: AnimatedSprite = $bf
@onready var percent_text: Alphabet = $percent/text

var percent = 0
var old_val = 0

func _ready() -> void:
	Audio.play_music("results/normal")
	await get_tree().create_timer(0.25).timeout
	sound_system.show()
	result.show()
	result.play("intro")
	sound_system.play("intro")
	await get_tree().create_timer(0.5).timeout
	ratings.show()
	ratings.play("intro")
	score.show()
	score.play("intro")
	await get_tree().create_timer(0.5).timeout
	do_text_shit()

func _process(delta: float) -> void:
	percent_text.text = str(percent)

	if old_val != percent:
		Audio.play_sound("scrollMenu")
		old_val = percent

func do_text_shit():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "percent", 69, 2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	await tween.finished
	tween.kill()
	$percent/flash.play('flash')
	Audio.play_sound("confirmMenu")
	animate()

func animate():
	bf.show()
	bf.play("intro")
	await get_tree().create_timer(0.25).timeout
	gf.show()
	gf.play("intro")
	await bf.animation_finished
	gf.play("loop")
	bf.play("loop")
