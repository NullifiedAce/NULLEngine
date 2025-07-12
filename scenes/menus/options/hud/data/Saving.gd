# Splitting saving into it's own node, as the editor node itself should only handle menu popups.
#
extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/AccuracyRanks/ScrollContainer/VBoxContainer"

func _save_hud(path: String):
	print("Saving current HUD...")

	var save_json:Dictionary = {
		"HUDLabel": [],
		"HUDBar": [],
		"AccuracyRanks": [],
	}

	HUDHandler.hud_labels.clear()
	HUDHandler.hud_bars.clear()
	HUDHandler.accuracy_ranks.clear()

	for i in accuracy_ranks.get_children():
		if i is RankButton:
			var rank:HUDAccuracyRank = HUDAccuracyRank.new()
			rank.rank_name = i.rank_name.text
			rank.rank_accuracy = i.rank_accuracy.value
			rank.null_rank = i.null_rank

			save_json["AccuracyRanks"].append({
				"RankName": i.rank_name.text,
				"RankAccuracy": i.rank_accuracy.value,
				"NullRank": i.null_rank
			})
 
			HUDHandler.accuracy_ranks.append(rank)

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify({"HUD": save_json}, "\t"))
	file.close()

	SettingsAPI.set_setting("lastHudFile", path)

	print("Saved HUD!")
