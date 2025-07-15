extends CanvasLayer
class_name HUD

@export var game:Gameplay

func _ready() -> void:
	for i in HUDHandler.hud_elements:
		if i is HUDLabel:
			var new_label:HUDLabel = HUDLabel.new() # Gotta create a new one because duplicating gets rid of the global one when exiting the gameplay scene.
			
			new_label.label_position = i.label_position
			new_label.label_rotation = i.label_rotation

			new_label.text_items = i.text_items

			new_label.font = i.font
			new_label.font_color = i.font_color
			new_label.font_size = i.font_size

			new_label.outline_color = i.outline_color
			new_label.outline_size = i.outline_size

			new_label.shadow_color = i.shadow_color
			new_label.shadow_offset = i.shadow_offset
			new_label.shadow_size = i.shadow_size

			add_child(new_label)
