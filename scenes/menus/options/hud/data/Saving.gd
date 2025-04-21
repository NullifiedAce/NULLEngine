# Splitting saving into it's own node, as the editor node itself should only handle menu popups.
#

extends Node

@onready var hud_elements: Node = $'../HUDElements'

func save_hud():
	print("Saving current HUD...")

	HUDHandler.hud_labels.clear()

	for i:HUDElement in hud_elements.get_children():
		if i.current_type == 0:
			var hud_label = HUDLabel.new()
			var og_label = i.hud_label

			HUDHandler.hud_labels.append(save_label(hud_label, og_label, i))

	print("Saving HUD finished!")

func save_label(new:HUDLabel, old:HUDEditorLabel, element:HUDElement):
	new.position = element.position
	new.downscroll_multiplier = element.donwscroll_box.value
	new.rotation = element.rotation

	new.text = old.label_text.text

	new.track_value = old.track_value_check.button_pressed
	new.track = old.track_value.get_item_text(old.track_value.selected).to_lower()
	new.prefix = old.prefix_box.text
	new.suffix = old.suffix_box.text

	new.font = old.font_options.get_item_text(old.font_options.selected).to_lower()
	new.font_size = old.font_size.value
	new.font_color = old.font_color_picker.color.to_html()

	new.outline_color = old.outline_color_picker.color.to_html()
	new.outline_size = old.outline_size.value

	new.shadow_color = old.shadow_color_picker.color.to_html()
	new.shadow_size = old.shadow_size.value
	new.shadow_offset_x = old.shadow_offset_x.value
	new.shadow_offset_y = old.shadow_offset_y.value

	return new
