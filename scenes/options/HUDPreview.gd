extends CanvasLayer

@onready var hp_bar_x: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar X'
@onready var hp_bar_y: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar Y'
@onready var hp_bar_y_down_scroll: OptionsSpinBox = $'../Editor/TabContainer/Health Bar/HPBar Y DownScroll'
@onready var down_scroll: CheckBox = $'../Editor/TabContainer/Health Bar/UseDownScrollPos'

func _process(delta: float) -> void:
	if down_scroll.button_pressed:
		$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y_down_scroll.value)
	else:
		$HealthBar.position = Vector2(hp_bar_x.value, hp_bar_y.value)
