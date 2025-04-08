extends Window

@onready var custom_colors: OptionCheckbox = $ScrollContainer/VBoxContainer/ColorsCheckbox/CustomColors
@onready var player_col: Label = $ScrollContainer/VBoxContainer/PlayerCol
@onready var opp_color: Label = $ScrollContainer/VBoxContainer/OppColor

func _process(delta: float) -> void:
	player_col.visible = custom_colors.button_pressed
	opp_color.visible = custom_colors.button_pressed
