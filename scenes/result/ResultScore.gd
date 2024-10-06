@tool
@icon("res://editor/icons/resultScore.png")

extends ReferenceRect
class_name ResultScore

var scoreStart = 0

@export var digitCount:int
@export var scoreShit:int = 100

@onready var template: ScoreNum = $template_num
@onready var numbers: Node2D = $Numbers

func set_scoreShit(val):
	if numbers.get_child_count() == 0: return val
	var loopNum:int = numbers.get_child_count() - 1
	var dumbNumb = int(str(val))
	var prevNum: ScoreNum

	while dumbNumb > 0:
		scoreStart += 1
		numbers.get_child(loopNum).finalDigit = dumbNumb % 10

		dumbNumb = floor(dumbNumb / 10)
		loopNum -= 1

	while loopNum > 0:
		numbers.get_child(loopNum).digit = 10
		loopNum -= 1

	return val

func animateNumbers():
	for i in numbers.get_child_count():
		await get_tree().create_timer((i-1)/24).timeout
		numbers.get_child(i).finalDelay = scoreStart - (i-1)
		numbers.get_child(i).playAnim()
		numbers.get_child(i).shuffle()

func _ready() -> void:
	for i in digitCount:
		var number = template.duplicate()
		number.position.x = position.x + (65 * i)
		#number.position.y = position.y

		number.show()
		numbers.add_child(number)

func updateScore(scoreNew:int):
	scoreShit = scoreNew
