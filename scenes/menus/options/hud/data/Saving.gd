# Splitting saving into it's own node, as the editor node itself should only handle menu popups.
#
extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/Ranks/RankTypes/Accuracy Ranks/ScrollContainer/VBoxContainer"

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

	for i:HUDElement in hud_elements.get_children():
		if i.current_type == 0:
			var hud_label = HUDLabel.new()
			var og_label = i.hud_label
			var new_label = save_label(hud_label, og_label, i, save_json)

			HUDHandler.hud_labels.append(new_label)

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

func save_label(new:HUDLabel, old:HUDEditorLabel, element:HUDElement, save_data:Dictionary):
	new.position = element.position
	new.downscroll_multiplier = element.donwscroll_box.value
	new.rotation = element.rotation

	for i in old.item_array.get_children():
		if i is HUDTextButton:
			var new_item = {
				"text": i.default_text.text,
				"prefix_text": i.text_prefix.text,
				"suffix_text": i.text_suffix.text,
				"track": i.track_value_box.button_pressed,
				"track_value": i.track_value.get_item_text(i.track_value.selected)
			}

			new.items.append(new_item)
		if i is OptionButton:
			new.layout_mode_option = i.get_item_text(i.selected)

	new.font = old.font_options.get_item_text(old.font_options.selected).to_lower()
	new.font_size = old.font_size.value
	new.font_color = old.font_color_picker.color.to_html()

	new.outline_color = old.outline_color_picker.color.to_html()
	new.outline_size = old.outline_size.value

	new.shadow_color = old.shadow_color_picker.color.to_html()
	new.shadow_size = old.shadow_size.value
	new.shadow_offset_x = old.shadow_offset_x.value
	new.shadow_offset_y = old.shadow_offset_y.value

	save_data["HUDLabel"].append({
		"PosX": new.position.x,
		"PosY": new.position.y,
		"DownscrollMulti": new.downscroll_multiplier,
		"Rotation": new.rotation,

		"Items": new.items,
		"LayoutMode": new.layout_mode_option,

		"Font": new.font,
		"FontSize": new.font_size,
		"FontColor": new.font_color,

		"OutlineColor": new.outline_color,
		"OutlineSize": new.outline_size,

		"ShadowColor": new.shadow_color,
		"ShadowSize": new.shadow_size,
		"ShadowOffsetX": new.shadow_offset_x,
		"ShadowOffsetY": new.shadow_offset_y
	})

	return new
