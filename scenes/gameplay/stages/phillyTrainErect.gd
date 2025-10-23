extends Stage
@onready var train_sound = $train_sound
@onready var win: Sprite2D = $PL2/Win
@onready var train: Sprite2D = $PL3/Train
func _ready():
	Conductor.beat_hit.connect(beat_hit)
var trainCooldown:int = 0
var trainMoveing:bool = false
const colors:Array[int] = [0xFFFBA633,0xFF31A2FD,0xFFFB33F5,0xFF31FD8C,0xFFFD4531]
func beat_hit(beat:int):
	if not trainMoveing:
		trainCooldown += 1
	if beat%4 == 0:
		win.visible = true
		win.modulate = colors[randi_range(0,4)]
		create_tween().tween_property(win,"modulate:a",0.0,Conductor.crochet/255).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		# lightshit
	if beat%8 == 4 and randf_range(0,100) < 30.0 and !trainMoveing and trainCooldown > 8:
		trainCooldown = randi_range(-4,0)
		print(beat)
		start_train()
func start_train():
	trainMoveing = true
	train_sound.play()
	create_tween().tween_property(train,"position:x",-4000,1.5).set_delay(4.5).finished.connect(func(): train.position.x = 2010; trainMoveing = false)
