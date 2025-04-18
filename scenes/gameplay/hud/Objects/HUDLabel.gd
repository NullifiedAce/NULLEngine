extends Label
class_name HUDLabel

var downscroll_multiplier:float

var track_value:bool
var track:String

var prefix:String
var suffix:String

@onready var game: Gameplay = $'../..'

func _ready() -> void:
	if SettingsAPI.get_setting("downscroll"): position.y = position.y * downscroll_multiplier

func _process(delta: float) -> void:
	if track_value:
		text = prefix + str(game.score_values[track]) + suffix
