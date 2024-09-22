extends Node2D

@onready var result: AnimatedSprite2D = $BG/result
@onready var sound_system: AnimatedSprite2D = $BG/soundSystem
@onready var ratings: AnimatedSprite2D = $BG/ratings
@onready var score: AnimatedSprite2D = $BG/score
@onready var highscore: AnimatedSprite2D = $BG/highscore
@onready var gf: AnimatedSprite = $gf
@onready var bf: AnimatedSprite = $bf
@onready var percent_text: Alphabet = $percent/text
@onready var total: Alphabet = $BG/ratings/total
@onready var max_combo: Alphabet = $BG/ratings/max_combo
@onready var sicks: Alphabet = $BG/ratings/sicks
@onready var goods: Alphabet = $BG/ratings/goods
@onready var bads: Alphabet = $BG/ratings/bads
@onready var shits: Alphabet = $BG/ratings/shits
@onready var misses: Alphabet = $BG/ratings/misses


# used for tweening
var percent = 0
var old_val = 0

var int_total: int = 0
var int_max_combo: int = 0
var int_sicks: int = 0
var int_goods: int = 0
var int_bads: int = 0
var int_shits: int = 0
var int_misses: int = 0

var grade: int = 0

func _ready() -> void:
	Audio.play_music("results/normal")
	await get_tree().create_timer(0.25).timeout

	grade = (Ranking.final_sicks + Ranking.final_goods) / Ranking.hittable_notes * 100

	var tween = get_tree().create_tween()
	tween.tween_property($BG/BlackBar, "position", Vector2(640, 72), 0.25)
	sound_system.show()
	result.show()
	result.play("intro")
	sound_system.play("intro")
	await get_tree().create_timer(0.5).timeout
	result.play("loop")
	ratings.show()
	ratings.play("intro")
	await get_tree().create_timer(0.4).timeout
	do_rating_shit()
	score.show()
	score.play("intro")
	await get_tree().create_timer(0.1).timeout
	do_text_shit()

func _process(delta: float) -> void:
	percent_text.text = str(percent)

	total.text = str(int_total)
	max_combo.text = str(int_max_combo)
	sicks.text = str(int_sicks)
	goods.text = str(int_goods)
	bads.text = str(int_bads)
	shits.text = str(int_shits)
	misses.text = str(int_misses)

	if old_val != percent:
		Audio.play_sound("scrollMenu")
		old_val = percent

	if Input.is_action_just_pressed("ui_accept"):
		Global.switch_scene("res://scenes/FreeplayMenu.tscn")

func do_rating_shit():
	total.show()
	var total_tween = get_tree().create_tween()
	total_tween.tween_property(self, "int_total", Ranking.total_notes, 1)

	await get_tree().create_timer(0.1).timeout

	max_combo.show()
	var combo_tween = get_tree().create_tween()
	combo_tween.tween_property(self, "int_max_combo", Ranking.final_max_combo, 1)

	await get_tree().create_timer(0.1).timeout

	sicks.show()
	var sicks_tween = get_tree().create_tween()
	sicks_tween.tween_property(self, "int_sicks", Ranking.final_sicks, 1)

	await get_tree().create_timer(0.1).timeout

	goods.show()
	var goods_tween = get_tree().create_tween()
	goods_tween.tween_property(self, "int_goods", Ranking.final_goods, 1)

	await get_tree().create_timer(0.1).timeout

	bads.show()
	var bads_tween = get_tree().create_tween()
	bads_tween.tween_property(self, "int_bads", Ranking.final_bads, 1)

	await get_tree().create_timer(0.1).timeout

	shits.show()
	var shits_tween = get_tree().create_tween()
	shits_tween.tween_property(self, "int_shits", Ranking.final_shits, 1)

	await get_tree().create_timer(0.1).timeout

	misses.show()
	var misses_tween = get_tree().create_tween()
	misses_tween.tween_property(self, "int_misses", Ranking.final_misses, 1)

func do_text_shit():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "percent", grade, 2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	await tween.finished
	tween.kill()
	$percent/flash.play('flash')
	Audio.play_sound("confirmMenu")
	await get_tree().create_timer(0.5).timeout
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
