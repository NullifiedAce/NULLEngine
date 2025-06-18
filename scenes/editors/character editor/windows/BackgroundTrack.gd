extends Window

var buttons:Dictionary = {
	"play": preload("res://assets/images/material_icons/Editors/Play.svg"),
	"pause": preload("res://assets/images/material_icons/Editors/Pause.svg")
}

@onready var character_editor: MusicBeatScene = $"../.."

@onready var track: OptionButton = $Track
@onready var play: Button = $Play
@onready var lower: Button = $Lower
@onready var higher: Button = $Higher
@onready var bars: HBoxContainer = $Bars

func _ready() -> void:
	lower.pressed.connect(func():
		character_editor.track_volume = clampf(character_editor.track_volume - 0.1, 0.0, 1.0))
	higher.pressed.connect(func():
		character_editor.track_volume = clampf(character_editor.track_volume + 0.1, 0.0, 1.0))
	play.pressed.connect(func():
		character_editor.track_paused = !character_editor.track_paused)

func _process(delta: float) -> void:
	for i:ColorRect in bars.get_children():
		i.color = Color8(100, 100, 100, 255)
		if int(i.name) <= character_editor.track_volume * 10:
			i.color = Color.WHITE

	if character_editor.track_paused: play.icon = buttons["play"]
	else: play.icon = buttons["pause"]

func _on_track_selected(index: int) -> void:
	match index:
		0: character_editor.load_background_track("res://assets/music/chartEditorLoop.ogg")
		1: character_editor.load_background_track("res://assets/music/freakyMenu.ogg")
		2: character_editor.load_background_track("res://assets/music/breakfast.ogg")
