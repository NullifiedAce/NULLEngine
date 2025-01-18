extends Node2D

@onready var options: Node2D = $'..'

@onready var player_vis_percent: Label = $CenterRef/Player/OppOptions/PlayerVisibility/Percent
@onready var player_scale_percent: Label = $CenterRef/Player/OppOptions/PlayerSize/Percent
@onready var opp_vis_percent: Label = $CenterRef/Opponent/OppOptions/OppVisibility/Percent
@onready var opp_scale_percent: Label = $CenterRef/Opponent/OppOptions/OppSize/Percent

func _process(delta: float) -> void:
	if SettingsAPI.get_setting("downscroll"):
		$Player.position.y = Global.game_size.y - 100
		$Opponent.position.y = Global.game_size.y - 100
	else:
		$Player.position.y = 100
		$Opponent.position.y = 100
	$PlayerLabel.position.y = $Player.position.y + 60
	$OpponentLabel.position.y = $Opponent.position.y + 60

	$Player.modulate = Color(1, 1, 1, SettingsAPI.get_setting("playerStrumVis"))
	$Player.scale = Vector2(SettingsAPI.get_setting("playerStrumScale"), SettingsAPI.get_setting("playerStrumScale"))
	$Opponent.modulate = Color(1, 1, 1, SettingsAPI.get_setting("oppStrumVis"))
	$Opponent.scale = Vector2(SettingsAPI.get_setting("oppStrumScale"), SettingsAPI.get_setting("oppStrumScale"))

	player_vis_percent.text = str($CenterRef/Player/OppOptions/PlayerVisibility.value * 100) + "%"
	player_scale_percent.text = str($CenterRef/Player/OppOptions/PlayerSize.value * 100) + "%"
	opp_vis_percent.text = str($CenterRef/Opponent/OppOptions/OppVisibility.value * 100) + "%"
	opp_scale_percent.text = str($CenterRef/Opponent/OppOptions/OppSize.value * 100) + "%"

func _on_exit_button_pressed() -> void:
	options.switch.play_backwards("strumEditor")
	$'../TabContainer'.show()
	await options.switch.animation_finished
	hide()
