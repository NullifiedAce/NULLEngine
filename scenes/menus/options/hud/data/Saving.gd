# Splitting saving into it's own node, as the editor node itself should only handle menu popups.
#
extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/AccuracyRanks/ScrollContainer/VBoxContainer"

func _save_hud(path: String):
	print("Saving current HUD...")

	var save_json:Dictionary = {
		"HUDLabels": [],
		"AccuracyRanks": [],
	}

	HUDHandler.hud_elements.clear()
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

	for i in hud_elements.get_children():
		if i is HUDEditorLabel:
			var new_hud_label:HUDLabel = HUDLabel.new()

			new_hud_label.label_position = Vector2(i.pos_box_x.value, i.pos_box_y.value)
			new_hud_label.label_rotation = i.rot_box.value

			for e:HUDTextButton in i.text_buttons.get_children():
				var new_text_line:Dictionary = {
					"value_option": e.value_option.get_item_text(e.value_option.selected),
					"prefix": e.prefix_box.text,
					"suffix": e.suffix_box.text
				}
				new_hud_label.text_items.append(new_text_line)

			new_hud_label.font = i.font_option.get_item_text(i.font_option.selected).to_lower()
			new_hud_label.font_size = i.font_size.value
			new_hud_label.font_color = i.font_color.color.to_html()

			new_hud_label.outline_size = i.outline_size.value
			new_hud_label.outline_color = i.outline_color.color.to_html()

			new_hud_label.shadow_size = i.shadow_size.value
			new_hud_label.shadow_color = i.shadow_color.color.to_html()
			new_hud_label.shadow_offset = Vector2(
				i.shadow_offset_x.value,
				i.shadow_offset_y.value
			)

			HUDHandler.hud_elements.append(new_hud_label)
			save_json["HUDLabels"].append({
				"position": new_hud_label.label_position,
				"rotation": new_hud_label.label_rotation,

				"text_items": new_hud_label.text_items,

				"font": new_hud_label.font,
				"font_size": new_hud_label.font_size,
				"font_color": new_hud_label.font_color,

				"outline_size": new_hud_label.outline_size,
				"outline_color": new_hud_label.outline_color,

				"shadow_size": new_hud_label.shadow_size,
				"shadow_color": new_hud_label.shadow_color,
				"shadow_offset": new_hud_label.shadow_offset
			})

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify({"HUD": save_json}, "\t"))
	file.close()

	SettingsAPI.set_setting("lastHudFile", path)
	SettingsAPI.flush()

	print("Saved HUD!")
