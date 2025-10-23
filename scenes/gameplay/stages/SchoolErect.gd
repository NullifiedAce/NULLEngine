extends Stage

func _ready() -> void:
	if get_tree().current_scene is Gameplay:
		game = get_tree().current_scene

	$treesBG.play("trees")
	$"0-85/petals".play("PETALS ALL")
