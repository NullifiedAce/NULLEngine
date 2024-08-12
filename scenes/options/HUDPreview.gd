extends CanvasLayer

@onready var hp_bar_x: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar X'
@onready var hp_bar_y: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar Y'
@onready var down_scroll: CheckBox = $'../Editor/TabContainer/Health Bar/UseDownScrollPos'

func _process(delta: float) -> void:
	if SettingsAPI.get_setting("downscroll"):
		$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y.value * 0.1)
	else:
		$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y.value)
