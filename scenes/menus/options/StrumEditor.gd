extends Node2D

@onready var options: Node2D = $'..'

@onready var player_vis_percent: Label = $CenterRef/Player/OppOptions/PlayerVisibility/Percent
@onready var player_scale_percent: Label = $CenterRef/Player/OppOptions/PlayerSize/Percent
@onready var opp_vis_percent: Label = $CenterRef/Opponent/OppOptions/OppVisibility/Percent
@onready var opp_scale_percent: Label = $CenterRef/Opponent/OppOptions/OppSize/Percent

func _process(delta: float) -> void:
	if OptionsAPI.get_option("downscroll"):
		$Player.position.y = Global.game_size.y - 100
		$Opponent.position.y = Global.game_size.y - 100
	else:
		$Player.position.y = 100
		$Opponent.position.y = 100
	$PlayerLabel.position.y = $Player.position.y + 60
	$OpponentLabel.position.y = $Opponent.position.y + 60

	$Player.modulate = Color(1, 1, 1, OptionsAPI.get_option("playerStrumVis"))
	$Player.scale = Vector2(OptionsAPI.get_option("playerStrumScale"), OptionsAPI.get_option("playerStrumScale"))
	$Opponent.modulate = Color(1, 1, 1, OptionsAPI.get_option("oppStrumVis"))
	$Opponent.scale = Vector2(OptionsAPI.get_option("oppStrumScale"), OptionsAPI.get_option("oppStrumScale"))

	player_vis_percent.text = str($CenterRef/Player/OppOptions/PlayerVisibility.value * 100) + "%"
	player_scale_percent.text = str($CenterRef/Player/OppOptions/PlayerSize.value * 100) + "%"
	opp_vis_percent.text = str($CenterRef/Opponent/OppOptions/OppVisibility.value * 100) + "%"
	opp_scale_percent.text = str($CenterRef/Opponent/OppOptions/OppSize.value * 100) + "%"

func _on_exit_button_pressed() -> void:
	options.switch.play("FromStrum")
	options.strum_editor_open = false
