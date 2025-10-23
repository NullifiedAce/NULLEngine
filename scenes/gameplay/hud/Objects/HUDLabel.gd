class_name HUDLabel extends Label

var hud:HUD
var game:Gameplay

var label_position:Vector2 = Vector2.ZERO
var label_rotation:float = 0

var text_items:Array[Dictionary]

var font:String = "vcr"
var font_color:String = "ffffffff"
var font_size:int = 16

var outline_color:String = "000000ff"
var outline_size:int = 0

var shadow_color:String = "00000000"
var shadow_size:int = 0
var shadow_offset:Vector2 = Vector2.ZERO

func _ready():
	if get_parent() is not HUD:
		return

	hud = get_parent()
	game = hud.game

	position = label_position
	rotation = deg_to_rad(label_rotation)

	var new_label_settings = LabelSettings.new()

	new_label_settings.font = load("res://assets/fonts/"+font.to_lower()+".ttf")
	new_label_settings.font_color = Color.from_string(font_color, Color.WHITE)
	new_label_settings.font_size = font_size

	new_label_settings.outline_color = Color.from_string(outline_color, Color.BLACK)
	new_label_settings.outline_size = outline_size

	new_label_settings.shadow_color = Color.from_string(shadow_color, Color.TRANSPARENT)
	new_label_settings.shadow_size = shadow_size
	new_label_settings.shadow_offset = shadow_offset

	label_settings = new_label_settings

func _process(delta: float) -> void:
	if !hud: return

	text = ""
	for i in text_items:
		var new_text:String = i["prefix"] + str(Global.gameplay_values[i["value_option"].to_lower()]) + i["suffix"]
		text += new_text.replace("\\n", "\n")
