extends Button
class_name RankButton

@export var null_rank:bool = false

@onready var window: Window = $Window
@onready var rank_name: TextEdit = $Window/ScrollContainer/VBoxContainer/HBoxContainer/RankName
@onready var rank_accuracy: SpinBox = $Window/ScrollContainer/VBoxContainer/HBoxContainer2/RankAccuracy

@onready var delete: Button = $Delete

func _ready() -> void:
	pressed.connect(func():
		if window.visible: window.hide()
		else: window.show())

	if null_rank:
		delete.hide()

	delete.pressed.connect(func():
		queue_free())

	rank_accuracy.editable = not null_rank

func _process(delta: float) -> void:
	text = "Rank: " + rank_name.text + " | " + "Accuracy: " + str(rank_accuracy.value)
