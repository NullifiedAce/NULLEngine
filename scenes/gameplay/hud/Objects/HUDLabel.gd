extends Label
class_name HUDLabel

var output_text:String

var downscroll_multiplier:float

var use_offset:bool
var offsets: Vector2
var anchor_preset = 0
var alignment = 0

var items:Array[Dictionary]

var layout_mode_option:String

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

func _process(_delta: float) -> void:
	output_text = ""

	if SettingsAPI.get_setting("downscroll"): position.y = position.y * downscroll_multiplier

	for i in items:
		if layout_mode_option == "Single Line":
			if !i["track"]: output_text += i["text"]
			else: output_text += i["prefix_text"] + str(game.score_values[i["track_value"].to_lower()]) + i["suffix_text"]
		else:
			if !i["track"]: output_text += i["text"] + "\n"
			else: output_text += i["prefix_text"] + str(game.score_values[i["track_value"].to_lower()]) + i["suffix_text"] + "\n"

	text = output_text

	set_anchors_and_offsets_preset(anchor_preset)
	horizontal_alignment = alignment
	if use_offset: position = offsets
