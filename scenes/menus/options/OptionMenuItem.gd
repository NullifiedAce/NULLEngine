@tool
extends Alphabet
class_name OptionMenuItem

enum BindType {
	STANDARD,
	ALT
}

var menu:OptionsMenu

var variant:int = 0
var value:Variant
var text_duplicate:String
var description:String = ""
var key:String

var numeric_min:float
var numeric_max:float
var numeric_step:float
var numeric_value_multiplier:float
var numeric_suffix:String

var string_array:Array[String]

var bind_type:int

var update_checkbox:bool = true

var update_bind:bool = false

var can_update:bool = true

@onready var checkbox: AnimatedSprite2D = $Checkbox

func _ready():
	if !Engine.is_editor_hint():
		value = OptionsAPI.get_option(key)

		if variant == 2:
			text = text_duplicate + ": " + str(value * numeric_value_multiplier) + numeric_suffix
		elif variant == 3:
			text = text_duplicate + ": %d" % (value * numeric_value_multiplier) + numeric_suffix
		elif variant == 6:
			text = text_duplicate + ": " + str(value)
		if variant == 5:
			text = text_duplicate + ": " + value[bind_type]

func _process(delta):
	checkbox.visible = true if variant == 1 else false

	checkbox.position.x = size.x + 88

	if update_checkbox and variant == 1:
		if value == true:
			checkbox.offset = Vector2(6, -10)
			checkbox.play("selected")
		elif value == false:
			checkbox.offset = Vector2.ZERO
			checkbox.play("unselected")

	if is_menu_item and not Engine.is_editor_hint():
		var scaled_y = remap(target_y, 0, 1, 0, 1.3);

		var lerp_val:float = clamp(delta * 60 * 0.1, 0, 1)
		position.y = lerp(position.y, (scaled_y * y_mult) + (720 * 0.48) + y_add, lerp_val)
		if force_x:
			position.x = force_x
		else:
			position.x = lerp(position.x, (target_y * 20) + 90 + x_add, lerp_val)

func selection():
	if !can_update:
		return

	if variant == 2 or variant == 3:
		return # We don't want to make any selection when having a numeric option.

	if variant == 0:
		Audio.play_sound("confirmMenu")
		match text:
			"Reset save data?":
				HighScore.reset()

				OptionsAPI._options = OptionsAPI._default_options.duplicate(true)
				OptionsAPI.flush()
				OptionsAPI.update_settings()
				OptionsAPI.setup_binds()
			"Reset option data?":
				OptionsAPI._options = OptionsAPI._default_options.duplicate(true)
				OptionsAPI.flush()
				OptionsAPI.update_settings()
				OptionsAPI.setup_binds()
			"Reset highscore data?":
				HighScore.reset()
		return
	if variant == 6:
		scroll(1)
		return

	menu.selected = true

	Audio.play_sound("confirmMenu")

	match variant:
		1:
			can_update = false
			menu.selected = false
			update_checkbox = false
			OptionsAPI.set_option(key, not OptionsAPI.get_option(key))
			OptionsAPI.update_settings()
			value = OptionsAPI.get_option(key)
			checkbox.offset = Vector2(-6, -39)
			if value == true:
				checkbox.play("selecting animation")
			elif value == false:
				checkbox.play_backwards("selecting animation")
			checkbox.animation_finished.connect(func():
				update_checkbox = true
				can_update = true
			)
		4:
			menu.state = menu.MenuStates[text.replace(" >", "").to_upper()]
			menu.setup_state()
			menu.selected = false
		5:
			text = text_duplicate + ": ..."
			await get_tree().create_timer(0.1).timeout
			update_bind = true

func _input(event: InputEvent):
	if variant != 5:
		return

	if event is InputEventKey and update_bind:
		var key_str:String = OS.get_keycode_string(event.keycode)
		text = text_duplicate + ": " + key_str.to_upper()
		OptionsAPI._options[key][bind_type] = key_str.to_upper()
		OptionsAPI.flush()
		OptionsAPI.setup_binds()
		await get_tree().create_timer(0.1).timeout
		menu.selected = false
		update_bind = false

func scroll(change:float = 0):
	if !can_update:
		return

	if variant != 2 and variant != 3 and variant != 6:
		return

	Audio.play_sound("scrollMenu")

	if variant == 2 or variant == 3:
		value = clamp(value + (numeric_step * change), numeric_min, numeric_max)
	if variant == 6:
		var item:int = string_array.find(value)
		item = wrapi(item + change, 0, string_array.size())
		value = string_array[item]
		text = text_duplicate + ": " + str(value)

	OptionsAPI.set_option(key, value)
	OptionsAPI.update_settings()

	if variant == 2:
		text = text_duplicate + ": " + str(value * numeric_value_multiplier) + numeric_suffix
	elif variant == 3:
		text = text_duplicate + ": %d" % (value * numeric_value_multiplier) + numeric_suffix
