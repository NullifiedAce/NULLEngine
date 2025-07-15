extends Node

@onready var hud_elements: Node = $'../HUDElements'
@onready var accuracy_ranks: VBoxContainer = $"../Windows/Preferences/TabContainer/AccuracyRanks/ScrollContainer/VBoxContainer"

func load_hud():
	for i in HUDHandler.hud_elements:
		if i is HUDLabel:
			var new_editor_label:HUDEditorLabel = load("res://scenes/menus/options/hud/Elements/HUDEditorLabel.tscn").instantiate()
			hud_elements.add_child(new_editor_label)
			new_editor_label.pos_box_x.value = i.label_position.x
			new_editor_label.pos_box_y.value = i.label_position.y
			new_editor_label.rot_box.value = i.label_rotation

			for e in i.text_items:
				var new_text_button:HUDTextButton = load("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()
				new_editor_label.text_buttons.add_child(new_text_button)
				for f in new_text_button.value_option.item_count:
					if e["value_option"] == new_text_button.value_option.get_item_text(f):
						new_text_button.value_option.select(f)
				new_text_button.prefix_box.text = e["prefix"]
				new_text_button.suffix_box.text = e["suffix"]

			for e in new_editor_label.font_option.item_count:
				if i.font == new_editor_label.font_option.get_item_text(e).to_lower():
					new_editor_label.font_option.select(e)
			new_editor_label.font_size.value = i.font_size
			new_editor_label.font_color.color = Color.from_string(i.font_color, Color.WHITE)

			new_editor_label.outline_size.value = i.outline_size
			new_editor_label.outline_color.color = Color.from_string(i.outline_color, Color.BLACK)

			new_editor_label.shadow_size.value = i.shadow_size
			new_editor_label.shadow_color.color = Color.from_string(i.shadow_color, Color.TRANSPARENT)
			new_editor_label.shadow_offset_x.value = i.shadow_offset.x
			new_editor_label.shadow_offset_y.value = i.shadow_offset.y
			new_editor_label._on_apply_changes_pressed()

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

	for i in json["HUD"]["HUDLabels"]:
		var new_editor_label:HUDEditorLabel = load("res://scenes/menus/options/hud/Elements/HUDEditorLabel.tscn").instantiate()
		hud_elements.add_child(new_editor_label)
		new_editor_label.pos_box_x.value = StringHelper.string_to_vector2(i["position"]).x
		new_editor_label.pos_box_y.value = StringHelper.string_to_vector2(i["position"]).y
		new_editor_label.rot_box.value = i["rotation"]

		for e in i.text_items:
			var new_text_button:HUDTextButton = load("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()
			new_editor_label.text_buttons.add_child(new_text_button)
			for f in new_text_button.value_option.item_count:
				if e["value_option"] == new_text_button.value_option.get_item_text(f):
					new_text_button.value_option.select(f)
			new_text_button.prefix_box.text = e["prefix"]
			new_text_button.suffix_box.text = e["suffix"]

		for e in new_editor_label.font_option.item_count:
			if i["font"] == new_editor_label.font_option.get_item_text(e).to_lower():
				new_editor_label.font_option.select(e)
		new_editor_label.font_size.value = i["font_size"]
		new_editor_label.font_color.color = Color.from_string(i["font_color"], Color.WHITE)

		new_editor_label.outline_size.value = i["outline_size"]
		new_editor_label.outline_color.color = Color.from_string(i["outline_color"], Color.BLACK)

		new_editor_label.shadow_size.value = i["shadow_size"]
		new_editor_label.shadow_color.color = Color.from_string(i["shadow_color"], Color.TRANSPARENT)
		new_editor_label.shadow_offset_x.value = StringHelper.string_to_vector2(i["shadow_offset"]).x
		new_editor_label.shadow_offset_y.value = StringHelper.string_to_vector2(i["shadow_offset"]).y
		new_editor_label._on_apply_changes_pressed()
