class_name HUDEditorLabel extends Label

var hud_editor:HUDEditor

var drag:bool = false
var mouse_pressed:bool = false
var mouse_hovered:bool = false

#region Edit Window Nodes
@onready var edit_window: Window = $EditWindow
@onready var pos_box_x: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Position/PositionX
@onready var pos_box_y: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Position/PositionY
@onready var rot_box: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Rotation
@onready var customize_button: Button = $EditWindow/ScrollContainer/VBoxContainer/Customize
@onready var edit_text_button: Button = $EditWindow/ScrollContainer/VBoxContainer/EditText
#endregion

#region Edit Text Window Nodes
@onready var edit_text_window: Window = $EditText
@onready var add_text_button: Button = $EditText/AddButton
@onready var text_buttons: VBoxContainer = $EditText/ScrollContainer/VBoxContainer
#endregion

#region Edit Style Window Nodes
@onready var edit_style_window: Window = $EditStyle
## Font Values
@onready var font_option: OptionButton = $EditStyle/ScrollContainer/VBoxContainer/Font/FontOption
@onready var font_size: SpinBox = $EditStyle/ScrollContainer/VBoxContainer/Font/Size
@onready var font_color: ColorPickerButton = $EditStyle/ScrollContainer/VBoxContainer/Font/Color
## Outline Values
@onready var outline_size: SpinBox = $EditStyle/ScrollContainer/VBoxContainer/Outline/Size
@onready var outline_color: ColorPickerButton = $EditStyle/ScrollContainer/VBoxContainer/Outline/Color
## Shadow Values
@onready var shadow_size: SpinBox = $EditStyle/ScrollContainer/VBoxContainer/Shadow/Size
@onready var shadow_color: ColorPickerButton = $EditStyle/ScrollContainer/VBoxContainer/Shadow/Color
@onready var shadow_offset_x: SpinBox = $EditStyle/ScrollContainer/VBoxContainer/Shadow2/OffsetX
@onready var shadow_offset_y: SpinBox = $EditStyle/ScrollContainer/VBoxContainer/Shadow2/OffsetY
#endregion

@onready var text_button:HUDTextButton = preload("res://scenes/menus/options/hud/Elements/HUDTextButton.tscn").instantiate()

func _ready():
	if get_parent().get_parent() is HUDEditor: # Check if the node we're looking for is the HUD Editor.
		hud_editor = get_parent().get_parent()
	else:
		printerr(str(get_parent().get_parent())+" is not class \"HUDEditor\".")
		queue_free() # Remove the node to prevent a potential crash.

	mouse_entered.connect(func():
		hud_editor.hovered_object = self
		mouse_hovered = true)
	mouse_exited.connect(func():
		hud_editor.hovered_object = null if !hud_editor.add_popup.visible else self
		mouse_hovered = false if !mouse_pressed else true
		)
	edit_text_button.pressed.connect(func():
		edit_text_window.visible = not edit_text_window.visible)
	customize_button.pressed.connect(func():
		edit_style_window.visible = not edit_style_window.visible)

	add_text_button.pressed.connect(func():
		var new_button = text_button.duplicate()
		text_buttons.add_child(new_button)
	)

func _process(_delta: float) -> void:
	if !drag: position = Vector2(pos_box_x.value, pos_box_y.value)
	rotation = deg_to_rad(rot_box.value)

	drag = mouse_hovered and mouse_pressed

	text = ""
	for i:HUDTextButton in text_buttons.get_children():
		text += i.text.replace("\\n", "\n")
	if text == "": text = "No custom text is present."

func _input(event: InputEvent) -> void:
	if event.is_action("drag"):
		if event.is_pressed(): mouse_pressed = true
		else: mouse_pressed = false
	elif event is InputEventMouseMotion and drag:
		position = get_global_mouse_position()
		pos_box_x.value = position.x
		pos_box_y.value = position.y

func _on_apply_changes_pressed() -> void:
	var new_label_settings = LabelSettings.new()

	new_label_settings.font = load("res://assets/fonts/"+font_option.get_item_text(font_option.selected).to_lower()+".ttf")
	new_label_settings.font_color = font_color.color
	new_label_settings.font_size = font_size.value

	new_label_settings.outline_color = outline_color.color
	new_label_settings.outline_size = outline_size.value

	new_label_settings.shadow_color = shadow_color.color
	new_label_settings.shadow_size = shadow_size.value
	new_label_settings.shadow_offset = Vector2(
		shadow_offset_x.value,
		shadow_offset_y.value
	)

	label_settings = new_label_settings

func _on_load_defaults_pressed() -> void:
	font_option.select(EngineTheme.get_theme_data("Label Font"))
	font_color.color = Color.from_string(EngineTheme.get_theme_data("Label Font Color"), Color.WHITE)
	font_size.value = EngineTheme.get_theme_data("Label Font Size")

	outline_color.color = Color.from_string(EngineTheme.get_theme_data("Label Outline Color"), Color.BLACK)
	outline_size.value = EngineTheme.get_theme_data("Label Outline Size")

	shadow_color.color = Color.from_string(EngineTheme.get_theme_data("Label Shadow Color"), Color.TRANSPARENT)
	shadow_size.value = EngineTheme.get_theme_data("Label Shadow Size")
	shadow_offset_x.value = EngineTheme.get_theme_data("Label Shadow Offset X")
	shadow_offset_y.value = EngineTheme.get_theme_data("Label Shadow Offset Y")

	_on_apply_changes_pressed()
