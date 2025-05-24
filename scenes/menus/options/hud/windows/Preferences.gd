extends Window

@onready var accuracy_ranks: VBoxContainer = $"TabContainer/Ranks/RankTypes/Accuracy Ranks/ScrollContainer/VBoxContainer"
@onready var add_accuracy_rank_button: Button = $"TabContainer/Ranks/RankTypes/Accuracy Ranks/ScrollContainer/VBoxContainer/AddRank"

func _ready() -> void:
	add_accuracy_rank_button.pressed.connect(add_accuracy_rank)

func add_accuracy_rank():
	var rank_button = load("res://scenes/menus/options/hud/Elements/RankButton.tscn").instantiate()

	accuracy_ranks.add_child(rank_button)
