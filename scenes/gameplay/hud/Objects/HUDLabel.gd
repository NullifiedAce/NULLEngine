extends Label
class_name HUDLabel

var downscroll_multiplier:float

var track_value:bool
var track:String

var prefix:String
var suffix:String

var font:String = "vcr"
var font_color:String = "ffffffff"
var font_size:int = 16

var outline_color:String = "000000ff"
var outline_size:int = 0

var shadow_color:String = "00000000"
var shadow_size:int = 0
var shadow_offset_x:int = 0
var shadow_offset_y:int = 0

@onready var game: Gameplay = $'../..'

func _ready() -> void:
	if SettingsAPI.get_setting("downscroll"): position.y = position.y * downscroll_multiplier

func _process(delta: float) -> void:
	if track_value:
		text = prefix + str(game.score_values[track.to_lower()]) + suffix
