extends MusicBeatScene

# Add new pages here, please do not remove any of these in your final build. We don't want people go uncredited for their work.
var pages = {
	"NULL Engine": preload("res://scenes/menus/credits/pages/NULL Engine.tscn"),
	"Nova Engine": preload("res://scenes/menus/credits/pages/Nova Engine.tscn"),
	"Addons": preload("res://scenes/menus/credits/pages/Addons.tscn"),
	"Funkin' Crew": preload("res://scenes/menus/credits/pages/Funkin Crew.tscn"),
}

@onready var credits_items: VBoxContainer = $CanvasLayer/CreditsItems/VBoxContainer

var selected:int = 0:
	set(v):
		selected = wrapi(v, 0, 4)

@export var category:Array[String]

@onready var title_sprite: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D
@onready var title: Label = $CanvasLayer/Title

func _ready() -> void:
	title_sprite.play("selected")

	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)

	change_page()

func _process(delta: float) -> void:
	title.size.x = 0
	title.text = "<Q " + category[selected] + " E>"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_freeplay_left"):
		selected -= 1
		change_page()
	if Input.is_action_just_pressed("ui_freeplay_right"):
		selected += 1
		change_page()

	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")
		Global.switch_scene("res://scenes/menus/main menu/Menu.tscn")

func change_page():
	for i in credits_items.get_children(): i.queue_free()

	var path = pages[category[selected]].instantiate()
	credits_items.add_child(path)

	for i in path.get_children():
		i.reparent(credits_items)
		if i is CreditsItem: i.load_pfp()
	path.queue_free()
