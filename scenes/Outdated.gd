extends MusicBeatScene

var new_version: String

func _ready() -> void:
	super._ready()

	RichPresence.set_text("Outdated Version!!", "")

	$Control/text.text = "Looks like your engine is outdated!
		The version your running on is currently Version %s, whilst
		the most up-to-date version is Version %s.\n
		Please go to any of these sites to get the latest build!\nWhen one link is opened this engine will close itself" % [Global.game_version, Global.new_version]

func _process(delta: float) -> void:
	if Input.is_key_label_pressed(KEY_ESCAPE):
		Global.switch_scene("res://scenes/MainMenu.tscn")
