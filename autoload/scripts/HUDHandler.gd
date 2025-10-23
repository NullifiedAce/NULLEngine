extends Node

var hud_elements:Array
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

	for i in json["HUD"]["HUDLabels"]:
		var new_label:HUDLabel = HUDLabel.new()
		hud_elements.append(new_label)
		new_label.label_position = StringHelper.string_to_vector2(i["position"])
		new_label.label_rotation = i["rotation"]

		for e in i["text_items"]:
			new_label.text_items.append(e)

		new_label.font = i["font"]
		new_label.font_size = i["font_size"]
		new_label.font_color = i["font_color"]

		new_label.outline_size = i["outline_size"]
		new_label.outline_color = i["outline_color"]

		new_label.shadow_size = i["shadow_size"]
		new_label.shadow_color = i["shadow_color"]
		new_label.shadow_offset= StringHelper.string_to_vector2(i["shadow_offset"])
