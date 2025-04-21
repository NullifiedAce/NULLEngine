extends Node

@onready var hud_elements: Node = $'../HUDElements'

func load_hud():
	for i in HUDHandler.hud_labels:
		if i is HUDLabel:
			load_labe(i)
		else:
			print(str(i.name) + " is not a HUDLabel! Perhaps the save path is wrong for this node?")

func load_labe(old:HUDLabel):
	var element:HUDElement = load("res://scenes/menus/options/hud/Elements/HUDElement.tscn").instantiate()

	element.current_type = 0

	element.x_pos_box.value = old.position.x
	element.y_pos_box.value = old.position.y
	element.rotation_box.value = old.rotation

	hud_elements.add_child(element)
