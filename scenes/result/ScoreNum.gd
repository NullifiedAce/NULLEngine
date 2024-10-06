@tool
extends AnimatedSprite2D
class_name ScoreNum

var digit:int = 10
var finalDigit:int = 10
var glow:bool = true

func set_finalDigit(val):
	play("GONE")

	finalDigit = val
	return finalDigit

func set_digit(val):
	if val >= 0 and animation != null and animation != numToString[val]:
		if glow:
			play(numToString[val])
			glow = false
		else:
			play(numToString[val])
			frame = 4

	finalDigit = val
	return finalDigit

var shuffleTimer = Timer.new()
var finalDelay:float = 0

func playAnim():
	play(numToString[digit])

var numToString:Array = ["ZERO", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "DISABLED"]

func finishShuffleTween():
	var finalTween = get_tree().create_tween()

	var tweenFunction = func(x):
		var digitRounded = floor(x)
		digit = digitRounded

	finalDigit = 0
	finalTween.tween_property(self, "finalDigit", digit, 23/24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tweenFunction
	await finalTween.finished
	await get_tree().create_timer(finalDelay).timeout
	play(animation)

var loops:int = 0

func shuffleProgress(shuffleTimer:Timer):
	var tempDigit:int = digit
	tempDigit += 1
	if tempDigit > 9: tempDigit = 0
	if tempDigit < 0: tempDigit = 0
	digit = tempDigit

	if loops == 0:
		finishShuffleTween()

func shuffle():
	# had to type this shit because godot somehow rounded these fuckers
	var duration:float = 1.7083333333333333333333333333333
	var interval:float = 0.04166666666666666666666666666667

	loops = int(duration / interval)

	shuffleTimer.wait_time = interval
	add_child(shuffleTimer)
	for n in range(int(duration / interval)):
		shuffleTimer.start()
		loops -= 1
		await shuffleTimer.timeout
		shuffleProgress(shuffleTimer)

func _ready() -> void:
	self.digit = 10
	play(numToString[digit])
