extends Node

var hud_labels:Array
var hud_bars:Array
var accuracy_ranks:Array

func _ready() -> void:
	load_hud()

func load_hud():
	var json = JSON.parse_string(FileAccess.open(SettingsAPI.get_setting("lastHudFile"), FileAccess.READ).get_as_text())

	if not "HUD" in json:
		print("Failed to load JSON. JSON doesn't contain \"HUD\". JSON: " + str(json))
		return

	for i in json["HUD"]["AccuracyRanks"]:
		var rank:HUDAccuracyRank = HUDAccuracyRank.new()

		rank.rank_name = i["RankName"]
		rank.rank_accuracy = i["RankAccuracy"]
		rank.null_rank = i["NullRank"]

		accuracy_ranks.append(rank)
