extends Node

@onready var hud_elements: Node = $'../HUDElements'

func load_hud():
	for i in HUDHandler.hud_labels:
		if i is HUDLabel:
			load_label(i)
		else:
			print(str(i.name) + " is not a HUDLabel! Perhaps the save path is wrong for this node?")

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
