extends MusicBeatScene

var flashing:bool = false
var page:int = 0

@onready var flash:ColorRect = $Flash
@onready var pages: Control = $Pages
@onready var next_page: TextureButton = $NextPage
@onready var previous_page: TextureButton = $PreviousPage

func _ready() -> void:
	super._ready()
	Audio.play_music("breakfast")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and page == 3:
		do_flash(1.0)
		Audio.play_sound("menus/confirmMenu")
		SettingsAPI.set_setting("first launch", false)
		SettingsAPI.flush()

		var timer:SceneTreeTimer = get_tree().create_timer(2.0)
		timer.timeout.connect(func():
			Global.switch_scene("res://scenes/menus/title/Menu.tscn")
		)

func switch_page(switch:int):
	page = clamp(page + switch, 0, 3)

	for i in pages.get_children():
		i.hide()

	pages.get_child(page).show()

	if page == 0:
		previous_page.hide()
	else:
		previous_page.show()

	if page == 3:
		next_page.hide()
		$'flashing lights'.show()
	else:
		next_page.show()
		$'flashing lights'.hide()

func do_flash(duration:float = 4.0):
	if flashing: return

	flashing = true
	flash.modulate.a = 1.0
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, duration)
	tween.finished.connect(func(): flashing = false)

func url_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_next_page_pressed() -> void:
	switch_page(1)

func _on_previous_page_pressed() -> void:
	switch_page(-1)
