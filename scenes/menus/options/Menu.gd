extends MusicBeatScene
class_name OptionsMenu

enum MenuStates {
	MAIN,
	CONTROLS,
	GAMEPLAY,
	APPEARANCE,
	AUDIO,
	WINDOW,
	MISCELLANEOUS,
	STRUMLINES,
	CAMERA,
	HUD,
	NOTES,
	UI,
	MENU,
	VOLUME
}

var state:MenuStates = MenuStates.MAIN

var cur_selected:int = 0
var selected:bool = false

@onready var title: Alphabet = $Control/Alphabet
@onready var template_option: Alphabet = $TemplateOption
@onready var options_group: CanvasGroup = $Options
@onready var description: Label = $Control/Description

func _ready() -> void:
	super._ready()
	Audio.play_music("freakyMenu")
	Conductor.change_bpm(Audio.music.stream.bpm)

	setup_state()

	change_selection()

func setup_state(remove_old:bool = true):
	if remove_old:
		for i in options_group.get_children():
			i.queue_free()

	var state_scene:OptionState = load("res://scenes/menus/options/states/"+str(MenuStates.find_key(state)).to_lower()+".tscn").instantiate()

	add_child(state_scene)

	title.text = state_scene.title

	for i in state_scene.options.size():
		var option:OptionMenuItem = template_option.duplicate()

		option.text = state_scene.options[i].option_name
		option.text_duplicate = option.text
		option.description = state_scene.options[i].option_description
		option.variant = state_scene.options[i].option_variant
		option.key = state_scene.options[i].option_key

		option.numeric_min = state_scene.options[i].numeric_min
		option.numeric_max = state_scene.options[i].numeric_max
		option.numeric_step = state_scene.options[i].numeric_step
		option.numeric_value_multiplier = state_scene.options[i].numeric_value_multiplier
		option.numeric_suffix = state_scene.options[i].numeric_suffix

		option.string_array = state_scene.options[i].string_array

		option.bind_type = state_scene.options[i].bind_type

		option.position = Vector2(2, (70 * i) + 30)
		option.show()
		option.is_menu_item = true
		option.target_y = i
		option.menu = self
		options_group.add_child(option)

	cur_selected = 0
	state_scene.queue_free()
	title.position.x = 640 - (title.size.x/2)
	await get_tree().create_timer(0.01/(OptionsAPI.get_option("fps")/120)).timeout
	change_selection()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("funkin_up") and !selected:
		change_selection(-1)
	if Input.is_action_just_pressed("funkin_down") and !selected:
		change_selection(1)
	if Input.is_action_just_pressed("funkin_cancel") or Input.is_action_just_pressed("mouse_right") and !selected:
		Audio.play_sound("cancelMenu")
		if state == MenuStates.MAIN:
			OptionsAPI.flush()
			var exit_scene_path:String = Global.scene_arguments["options_menu"].exit_scene_path

			if len(exit_scene_path) > 0:
				Global.switch_scene(exit_scene_path)
			else:
				Global.switch_scene("res://scenes/menus/main menu/Menu.tscn")
		elif state == MenuStates.CAMERA or state == MenuStates.HUD or state == MenuStates.STRUMLINES:
			state = MenuStates.APPEARANCE
			setup_state()
		elif state == MenuStates.NOTES or state == MenuStates.UI or state == MenuStates.MENU or state == MenuStates.VOLUME:
			state = MenuStates.CONTROLS
			setup_state()
		else:
			state = MenuStates.MAIN
			setup_state()
	if Input.is_action_just_pressed("funkin_left") and !selected:
		if !selected:
			options_group.get_child(cur_selected).scroll(-1)
	if Input.is_action_just_pressed("funkin_right") and !selected:
		if !selected:
			options_group.get_child(cur_selected).scroll(1)
	if Input.is_action_just_pressed("funkin_accept") or Input.is_action_just_pressed("mouse_left"):
		if !selected:
			options_group.get_child(cur_selected).selection()

func _input(e):
	if not e is InputEventMouseButton: return
	var event:InputEventMouseButton = e
	if not event.pressed: return

	match event.button_index:
		MOUSE_BUTTON_WHEEL_UP:
			if !selected: change_selection(-1)

		MOUSE_BUTTON_WHEEL_DOWN:
			if !selected: change_selection(1)

func change_selection(change:int = 0):
	cur_selected = wrapi(cur_selected + change, 0, options_group.get_child_count())

	for i in options_group.get_child_count():
		var option:OptionMenuItem = options_group.get_child(i)
		option.target_y = i - cur_selected
		option.modulate.a = 1.0 if cur_selected == i else 0.6
		if option.variant == 4:
			if cur_selected == i:
				option.text = option.text_duplicate + " >"
			else:
				option.text = option.text_duplicate

	description.text = options_group.get_child(cur_selected).description

	if change != 0: Audio.play_sound("scrollMenu")
