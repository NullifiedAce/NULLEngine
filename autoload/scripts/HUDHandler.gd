extends Node

var hud_labels:Array[HUDLabel]
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

	for i in json["HUD"]["HUDLabel"]:
		var element:HUDLabel = HUDLabel.new()

		# Main Values
		element.position.x = i["PosX"]
		element.position.y = i["PosY"]
		element.downscroll_multiplier = i["DownscrollMulti"]
		element.rotation = deg_to_rad(i["Rotation"])

		element.layout_mode_option = i["LayoutMode"]

		for f in i["Items"]:
			var item:Dictionary
			item["text"] = f["text"]
			item["prefix_text"] = f["prefix_text"]
			item["suffix_text"] = f["suffix_text"]
			item["track"] = f["track"]
			item["track_value"] = f["track_value"]

			element.items.append(item)

		element.font = i["Font"]
		element.font_size = i["FontSize"]
		element.font_color = i["FontColor"]

		element.outline_color = i["OutlineColor"]
		element.outline_size = i["OutlineSize"]

		element.shadow_color = i["ShadowColor"]
		element.shadow_size = i["ShadowSize"]
		element.shadow_offset_x = i["ShadowOffsetX"]
		element.shadow_offset_y = i["ShadowOffsetY"]

		HUDHandler.hud_labels.append(element)
