extends CanvasLayer
class_name HUD

@export var game:Gameplay

@onready var health_bar_bg: ColorRect = $HealthBar
@onready var health_bar: ProgressBar = $HealthBar/ProgressBar

@onready var player_icon: HealthIcon = $HealthBar/ProgressBar/PlayerIcon
@onready var cpu_icon: HealthIcon = $HealthBar/ProgressBar/CPUIcon

@onready var score_text: Label = $HealthBar/ScoreText

@onready var ratings: Label = $Ratings

@onready var time_bar: ProgressBar = $TimeBar
@onready var timer: Label = $TimeBar/Timer


#func _ready() -> void:
	#for i in HUDHandler.hud_elements:
		#if i is HUDLabel:
			#var new_label:HUDLabel = HUDLabel.new() # Gotta create a new one because duplicating gets rid of the global one when exiting the gameplay scene.
			#
			#new_label.label_position = i.label_position
			#new_label.label_rotation = i.label_rotation
#
			#new_label.text_items = i.text_items
#
			#new_label.font = i.font
			#new_label.font_color = i.font_color
			#new_label.font_size = i.font_size
#
			#new_label.outline_color = i.outline_color
			#new_label.outline_size = i.outline_size
#
			#new_label.shadow_color = i.shadow_color
			#new_label.shadow_offset = i.shadow_offset
			#new_label.shadow_size = i.shadow_size
#
			#add_child(new_label)

func setup_hud() -> void:
	health_bar.min_value = 0.0
	health_bar.max_value = game.max_health
	health_bar.value = lerp(health_bar.value, game.health, 0.05)

	update_health_bar()

	if SettingsAPI.get_setting("downscroll"):
		health_bar_bg.position.y *= 0.1
		time_bar.position.y = 690

	position_icons()

	update_score_text()

func update_health_bar():
	cpu_icon.texture = game.opponent.health_icon
	cpu_icon.hframes = game.opponent.health_icon_frames
	cpu_icon.texture_filter = game.opponent.health_icon_filter

	player_icon.texture = game.player.health_icon
	player_icon.hframes = game.player.health_icon_frames
	player_icon.texture_filter = game.player.health_icon_filter

func position_icons():
	var icon_offset:int = 26
	var percent:float = (health_bar.value / health_bar.max_value) * 100

	var cpu_icon_width:float = (cpu_icon.texture.get_width() / cpu_icon.hframes) * cpu_icon.scale.x

	player_icon.position.x = (health_bar.size.x * ((100 - percent) * 0.01)) - icon_offset
	cpu_icon.position.x = (health_bar.size.x * ((100 - percent) * 0.01)) - (cpu_icon_width - icon_offset)
	game.script_group.call_func("on_position_icons", [])

func update_score_text():
	var hp_percent:float = (health_bar.value / health_bar.max_value) * 100

	score_text.text = "Score: "+str(game.songScore)+\
		" - Accuracy: "+str(snapped(game.accuracy * 100.0, 0.01))+"%"+\
		" ["+Ranking.rank_from_accuracy(game.accuracy * 100.0).name+"]"

	ratings.text = "Sicks: %d" % game.sicks+\
		"\nGoods: %d" % game.goods+\
		"\nBads: %d" % game.bads+\
		"\nShits: %d" % game.shits+\
		"\n------------\n"+\
		"Misses: %d" % game.misses
		

	game.script_group.call_func("on_update_score_text", [])

func _process(delta: float) -> void:
	var percent:float = (game.health / game.max_health) * 100.0
	health_bar.max_value = game.max_health
	health_bar.value = lerp(health_bar.value, game.health, 0.075)

	time_bar.value = game.cur_time / game.max_time
	timer.text = str(Global.format_time(game.cur_time/1000)) + " / " + str(Global.format_time(game.max_time/1000))

	cpu_icon.health = 100.0 - percent
	player_icon.health = percent

	if game.icon_zooming:
		var icon_speed:float = clampf((delta * game.ICON_DELTA_MULTIPLIER) * Conductor.rate, 0.0, 1.0)
		cpu_icon.scale = lerp(cpu_icon.scale, Vector2(game.opponent.health_icon_scale, game.opponent.health_icon_scale), icon_speed)
		player_icon.scale = lerp(player_icon.scale, Vector2(game.player.health_icon_scale, game.player.health_icon_scale), icon_speed)
		position_icons()
