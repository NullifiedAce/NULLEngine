extends Window

@onready var char_scale: SpinBox = $ScrollContainer/VBoxContainer/CharScale
@onready var sprite_filter: OptionButton = $ScrollContainer/VBoxContainer/SpriteFilter

#region AnimDataNodes
@onready var is_animated: CheckBox = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/IsAnimated
@onready var is_player: CheckBox = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/IsPlayer
@onready var can_sing: CheckBox = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/CanSing
@onready var sing_dur: SpinBox = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/SingDur
@onready var dances: CheckBox = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/Dances
@onready var add_dance_steps: Button = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/AddDanceSteps
@onready var dance_step_groups: VBoxContainer = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/DanceStepGroups/VBoxContainer
@onready var add_combo_anim: Button = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/AddComboAnim
@onready var combo_anim_group: VBoxContainer = $ScrollContainer/VBoxContainer/AnimData/VBoxContainer/ComboAnimGroup/VBoxContainer
#endregion

#region HealthIconDataNodes
@onready var choose_health_icon: Button = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/ChooseHealthIcon
@onready var icon_preview: TextureRect = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/IconPreview
@onready var icon_scale: SpinBox = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/IconScale
@onready var icon_filter: OptionButton = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/IconFilter
@onready var icon_frames: SpinBox = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/IconFrames
@onready var icon_color: ColorPickerButton = $ScrollContainer/VBoxContainer/HealthIconData/VBoxContainer/IconColor
#endregion

#region DeathCharDataNodes
@onready var death_char: TextEdit = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/DeathChar
@onready var death_sound_button: Button = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/DeathSound
@onready var death_sound_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/DeathSound/PlayButton/DeathSoundPlayer
@onready var death_music_button: Button = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/DeathMusic
@onready var death_music_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/DeathMusic/PlayButton/DeathMusicPlayer
@onready var retry_sound_button: Button = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/RetrySound
@onready var retry_sound_player: AudioStreamPlayer = $ScrollContainer/VBoxContainer/DeathCharData/VBoxContainer/RetrySound/PlayButton/RetrySoundPlayer
#endregion

#region CharPathNodes
@onready var voices_path: TextEdit = $ScrollContainer/VBoxContainer/CharPathData/VBoxContainer/VoicesPath
@onready var char_script_path: TextEdit = $ScrollContainer/VBoxContainer/CharPathData/VBoxContainer/CharScriptPath
@onready var char_script_name: TextEdit = $ScrollContainer/VBoxContainer/CharPathData/VBoxContainer/CharScriptName
#endregion

@onready var health_icon_dialog: FileDialog = $"../HealthIcon"
@onready var death_sound_dialog: FileDialog = $"../DeathSoundDialog"
@onready var death_music_dialog: FileDialog = $"../DeathMusicDialog"
@onready var retry_sound_dialog: FileDialog = $"../RetrySoundDialog"

@onready var character_editor: CharacterEditor = $"../.."

func _ready() -> void:
	setup_signals()

func setup_signals():
	char_scale.value_changed.connect(func(value: float):
		character_editor.character_data.scale = value
		character_editor.character._setup()
	)

	sprite_filter.item_selected.connect(func(index: int):
		character_editor.character_data.filter = index
		character_editor.character.texture_filter = index as CanvasItem.TextureFilter
	)

	add_dance_steps.pressed.connect(add_dance_step_func)
	add_combo_anim.pressed.connect(add_combo_anim_func)

	choose_health_icon.pressed.connect(health_icon_dialog.show)
	icon_filter.item_selected.connect(func(index: int):
		icon_preview.texture_filter = index as CanvasItem.TextureFilter
	)

	health_icon_dialog.file_selected.connect(func(path: String):
		icon_preview.texture = load(path)
	)

	death_sound_button.pressed.connect(death_sound_dialog.show)
	death_sound_dialog.file_selected.connect(func(path: String):
		death_sound_player.stream = load(path)
	)
	death_music_button.pressed.connect(death_music_dialog.show)
	death_music_dialog.file_selected.connect(func(path: String):
		death_music_player.stream = load(path)
	)
	retry_sound_button.pressed.connect(retry_sound_dialog.show)
	retry_sound_dialog.file_selected.connect(func(path: String):
		retry_sound_player.stream = load(path)
	)

func load_data(character_data: CharacterData):
	char_scale.value = character_data.scale
	sprite_filter.select(character_data.filter)

	is_animated.button_pressed = character_data.is_animated
	is_player.button_pressed = character_data.is_player
	can_sing.button_pressed = character_data.can_sing
	sing_dur.value = character_data.sing_duration
	dances.button_pressed = character_data.dances

	for i in dance_step_groups.get_children():
		i.queue_free()
	for i in character_data.dance_steps:
		add_dance_step_func(i)

	icon_preview.texture = load(character_data.health_icon)
	icon_scale.value = character_data.health_icon_scale
	icon_filter.select(character_data.health_icon_filter)
	icon_frames.value = character_data.health_icon_frames
	icon_color.color = Color.from_string(character_data.health_color, "ffffff")

	death_char.text = character_data.death_character
	death_sound_player.stream = load(character_data.death_sound)
	death_music_player.stream = load(character_data.death_music)
	retry_sound_player.stream = load(character_data.retry_sound)

	voices_path.text = character_data.voices_path
	char_script_path.text = character_data.character_script_path
	char_script_name.text = character_data.character_script_name

func add_dance_step_func(text: String = ""):
	var text_edit:TextEdit = TextEdit.new()
	var delete_button:Button = Button.new()

	text_edit.context_menu_enabled = false
	text_edit.emoji_menu_enabled = false

	text_edit.custom_minimum_size.y = 32

	text_edit.text = text

	dance_step_groups.add_child(text_edit)

	delete_button.custom_minimum_size = Vector2.ONE*32
	delete_button.text = "x"

	delete_button.pressed.connect(func():
		text_edit.queue_free()
	)

	text_edit.add_child(delete_button)

	delete_button.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	delete_button.position.x -= 16

func add_combo_anim_func(combo: int = 0, anim: String = ""):
	var h_box:HBoxContainer = HBoxContainer.new()
	var spin_box:SpinBox = SpinBox.new()
	var text_edit:TextEdit = TextEdit.new()
	var delete_button:Button = Button.new()

	combo_anim_group.add_child(h_box)

	spin_box.max_value = INF
	spin_box.value = combo
	h_box.add_child(spin_box)

	text_edit.custom_minimum_size.x = 106
	text_edit.text = anim
	h_box.add_child(text_edit)

	delete_button.custom_minimum_size = Vector2.ONE*32
	delete_button.text = "x"

	delete_button.pressed.connect(func():
		h_box.queue_free()
	)
	h_box.add_child(delete_button)
