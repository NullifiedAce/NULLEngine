extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/Ranks/RankTypes/Accuracy Ranks/ScrollContainer/VBoxContainer"

func load_hud():
	for i in HUDHandler.hud_labels:
		if i is HUDLabel:
			load_label(i)
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

func load_label(old:HUDLabel):
	var element:HUDElement = load("res://scenes/menus/options/hud/Elements/HUDElement.tscn").instantiate()

	element.current_type = 0

	hud_elements.add_child(element)

	# Main Values
	element.x_pos_box.value = old.position.x
	element.y_pos_box.value = old.position.y
	element.donwscroll_box.value = old.downscroll_multiplier
	element.rotation_box.value = old.rotation

	var label = element.hud_label

	for i in label.item_array.get_children():
		if i is OptionButton:
			for e in i.item_count:
				if old.layout_mode_option == i.get_item_text(e):
					i.selected = e

	for i in old.items:
		var item = load("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()
		label.item_array.add_child(item)

		item.default_text.text = i["text"]
		item.text_prefix.text = i["prefix_text"]
		item.text_suffix.text = i["suffix_text"]
		item.track_value_box.button_pressed = i["track"]
		for e in item.track_value.item_count:
			if item.track_value.get_item_text(e) == i["track_value"]:
				item.track_value.selected = e

	for i in label.font_options.item_count:
		if label.font_options.get_item_text(i) == old.font:
			label.font_options.selected = i
	label.font_size.value = old.font_size
	label.font_color_picker.color = Color.from_string(old.font_color, Color.WHITE)

	label.outline_color_picker.color = Color.from_string(old.outline_color, Color.BLACK)
	label.outline_size.value = old.outline_size

	label.shadow_color_picker.color = Color.from_string(old.shadow_color, Color.TRANSPARENT)
	label.shadow_size.value = old.shadow_size
	label.shadow_offset_x.value = old.shadow_offset_x
	label.shadow_offset_y.value = old.shadow_offset_y

	label._on_reload_pressed()

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
		var element:HUDElement = load("res://scenes/menus/options/hud/Elements/HUDElement.tscn").instantiate()
		element.current_type = 0
		hud_elements.add_child(element)

		# Main Values
		element.x_pos_box.value = i["PosX"]
		element.y_pos_box.value = i["PosY"]
		element.donwscroll_box.value = i["DownscrollMulti"]
		element.rotation_box.value = i["Rotation"]

		var label = element.hud_label

		for f in label.item_array.get_children():
			if f is OptionButton:
				for e in f.item_count:
					if i["LayoutMode"] == f.get_item_text(e):
						f.selected = e

		for f in i["Items"]:
			var item = load("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()
			label.item_array.add_child(item)

			item.default_text.text = f["text"]
			item.text_prefix.text = f["prefix_text"]
			item.text_suffix.text = f["suffix_text"]
			item.track_value_box.button_pressed = f["track"]
			for e in item.track_value.item_count:
				if item.track_value.get_item_text(e) == f["track_value"]:
					item.track_value.selected = e

		for f in label.font_options.item_count:
			if label.font_options.get_item_text(f) == i["Font"]:
				label.font_options.selected = f
		label.font_size.value = i["FontSize"]
		label.font_color_picker.color = Color.from_string(i["FontColor"], Color.WHITE)

		label.outline_color_picker.color = Color.from_string(i["OutlineColor"], Color.BLACK)
		label.outline_size.value = i["OutlineSize"]

		label.shadow_color_picker.color = Color.from_string(i["ShadowColor"], Color.TRANSPARENT)
		label.shadow_size.value = i["ShadowSize"]
		label.shadow_offset_x.value = i["ShadowOffsetX"]
		label.shadow_offset_y.value = i["ShadowOffsetY"]

		label._on_reload_pressed()
