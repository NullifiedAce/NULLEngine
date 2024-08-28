extends Node

const HUDPresetFolder:String = "user://HUDPresets"

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(HUDPresetFolder):
		DirAccess.make_dir_absolute(HUDPresetFolder)
