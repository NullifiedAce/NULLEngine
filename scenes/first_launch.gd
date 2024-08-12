extends MusicBeatScene

var flashing:bool = false

@onready var flash:ColorRect = $Flash

func _ready() -> void:
	super._ready()
	Audio.play_music("breakfast")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		do_flash(1.0)
		Audio.play_sound("menus/confirmMenu")
		SettingsAPI.set_setting("first launch", false)
		SettingsAPI.flush()

		var timer:SceneTreeTimer = get_tree().create_timer(2.0)
		timer.timeout.connect(func():
			Global.switch_scene("res://scenes/TitleScreen.tscn")
		)

func do_flash(duration:float = 4.0):
	if flashing: return

	flashing = true
	flash.modulate.a = 1.0
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, duration)
	tween.finished.connect(func(): flashing = false)
