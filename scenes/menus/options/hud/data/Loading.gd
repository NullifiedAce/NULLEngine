extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/AccuracyRanks/ScrollContainer/VBoxContainer"

func load_hud():
	for i in HUDHandler.hud_labels:
		pass
	for i in HUDHandler.accuracy_ranks:
		if i is HUDAccuracyRank:
			var rank:RankButton = load("res://scenes/menus/options/hud/Elements/RankButton.tscn").instantiate()
			accuracy_ranks.add_child(rank)

			if i.null_rank:
				for e in accuracy_ranks.get_children():
					if e is RankButton and e.null_rank:
						e.rank_name.text = i.rank_name
						e.rank_accuracy.value = i.rank_accuracy
						rank.queue_free()
			else:
				rank.rank_name.text = i.rank_name
				rank.rank_accuracy.value = i.rank_accuracy

func _on_hud_opened(path: String) -> void:
	var json = JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())

	if not "HUD" in json:
		print("Failed to load JSON. JSON doesn't contain \"HUD\". JSON: " + str(json))
		return

	for i in hud_elements.get_children():
		i.queue_free()

	for i in accuracy_ranks.get_children():
		if i is RankButton and !i.null_rank:
			i.queue_free()

	for i in json["HUD"]["AccuracyRanks"]:
		var rank:RankButton = load("res://scenes/menus/options/hud/Elements/RankButton.tscn").instantiate()
		accuracy_ranks.add_child(rank)

		if i["NullRank"]:
			for e in accuracy_ranks.get_children():
				if e is RankButton and e.null_rank:
					e.rank_name.text = i["RankName"]
					e.rank_accuracy.value = i["RankAccuracy"]
					rank.queue_free()
		else:
			rank.rank_name.text = i["RankName"]
			rank.rank_accuracy.value = i["RankAccuracy"]

	for i in json["HUD"]["HUDLabel"]:
		pass
