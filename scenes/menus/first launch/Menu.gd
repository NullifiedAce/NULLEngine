extends MusicBeatScene

var flashing:bool = false
var page:int = 0
var enter:bool = false

@onready var flash:ColorRect = $Flash
@onready var pages: Control = $Pages
@onready var next_page: TextureButton = $NextPage
@onready var previous_page: TextureButton = $PreviousPage

func _ready() -> void:
	super._ready()
	Audio.play_music("breakfast")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and !enter:
		enter = true
		do_flash(1.0)
		Audio.play_sound("menus/confirmMenu")
		SettingsAPI.set_setting("first launch", false)
		SettingsAPI.flush()

		var timer:SceneTreeTimer = get_tree().create_timer(2.0)
		timer.timeout.connect(func():
			Global.switch_scene("res://scenes/menus/title/Menu.tscn")
		)

func do_flash(duration:float = 4.0):
	if flashing: return

	flashing = true
	flash.modulate.a = 1.0
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, duration)
	tween.finished.connect(func(): flashing = false)
