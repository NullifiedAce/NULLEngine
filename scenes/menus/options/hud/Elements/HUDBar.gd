extends ProgressBar
class_name HUDBar

var parent = HUDElement

@onready var size_x: SpinBox = $Sizes/SizeX
@onready var size_y: SpinBox = $Sizes/SizeY
@onready var fill_mode_option: OptionButton = $FillMode

# Background Style
@onready var bg_bg_color: ColorPickerButton = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Colors/BGColor
@onready var bg_border_color: ColorPickerButton = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Colors/BorderColor
@onready var bg_shadow_color: ColorPickerButton = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Colors/ShadowColor

@onready var bg_left_width: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Border/LeftWidth
@onready var bg_top_width: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Border/TopWidth
@onready var bg_right_width: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Border/RightWidth
@onready var bg_bottom_width: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/Border/BottomWidth

@onready var bg_top_left: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ConrerRadius/TopLeft
@onready var bg_top_right: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ConrerRadius/TopRight
@onready var bg_bottom_left: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ConrerRadius2/BottomLeft
@onready var bg_bottom_right: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ConrerRadius2/BottomRight

@onready var bg_left_margin: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ExpandMargins/LeftWidth
@onready var bg_top_margin: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ExpandMargins/TopWidth
@onready var bg_right_margin: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ExpandMargins/RightWidth
@onready var bg_bottom_margin: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/ExpandMargins/BottomWidth

@onready var bg_shadow_size: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/HBoxContainer/ShadowSize
@onready var bg_shadow_offset_x: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/HBoxContainer/ShadowOffsetX
@onready var bg_shadow_offset_y: SpinBox = $CustomizeWindow/TabContainer/Background/ScrollContainer/VBoxContainer/HBoxContainer/ShadowOffsetY

# Fill Style
@onready var fill_bg_color: ColorPickerButton = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Colors/BGColor
@onready var fill_border_color: ColorPickerButton = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Colors/BorderColor
@onready var fill_shadow_color: ColorPickerButton = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Colors/ShadowColor

@onready var fill_left_width: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Border/LeftWidth
@onready var fill_top_width: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Border/TopWidth
@onready var fill_right_width: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Border/RightWidth
@onready var fill_bottom_width: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/Border/BottomWidth

@onready var fill_top_left: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ConrerRadius/TopLeft
@onready var fill_top_right: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ConrerRadius/TopRight
@onready var fill_bottom_left: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ConrerRadius2/BottomLeft
@onready var fill_bottom_right: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ConrerRadius2/BottomRight

@onready var fill_left_margin: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ExpandMargins/LeftWidth
@onready var fill_top_margin: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ExpandMargins/TopWidth
@onready var fill_right_margin: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ExpandMargins/RightWidth
@onready var fill_bottom_margin: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/ExpandMargins/BottomWidth

@onready var fill_shadow_size: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/HBoxContainer/ShadowSize
@onready var fill_shadow_offset_x: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/HBoxContainer/ShadowOffsetX
@onready var fill_shadow_offset_y: SpinBox = $CustomizeWindow/TabContainer/Fill/ScrollContainer/VBoxContainer/HBoxContainer/ShadowOffsetY

@onready var customize_window: Window = $CustomizeWindow

func _ready() -> void:
	_on_reload_pressed()

func _process(delta: float) -> void:
	size = Vector2(size_x.value, size_y.value)

func _on_customize_pressed() -> void:
	if customize_window.visible: customize_window.hide()
	else: customize_window.show()

func _on_reload_pressed() -> void:
	apply_background()
	apply_fill()

func apply_background():
	var s:StyleBoxFlat = StyleBoxFlat.new()

	s.bg_color = bg_bg_color.color

	s.border_width_left = bg_left_width.value
	s.border_width_top = bg_top_width.value
	s.border_width_right = bg_right_width.value
	s.border_width_bottom = bg_bottom_width.value

	s.border_color = bg_border_color.color

	s.corner_radius_top_left = bg_top_left.value
	s.corner_radius_top_right = bg_top_right.value
	s.corner_radius_bottom_right = bg_bottom_right.value
	s.corner_radius_bottom_left = bg_bottom_left.value

	s.expand_margin_left = bg_left_margin.value
	s.expand_margin_top = bg_top_margin.value
	s.expand_margin_right = bg_right_margin.value
	s.expand_margin_bottom = bg_bottom_margin.value

	s.shadow_color = bg_shadow_color.color
	s.shadow_size = bg_shadow_size.value
	s.shadow_offset = Vector2(bg_shadow_offset_x.value, bg_shadow_offset_x.value)

	add_theme_stylebox_override('background', s)

func apply_fill():
	var s:StyleBoxFlat = StyleBoxFlat.new()

	s.bg_color = fill_bg_color.color

	s.border_width_left = fill_left_width.value
	s.border_width_top = fill_top_width.value
	s.border_width_right = fill_right_width.value
	s.border_width_bottom = fill_bottom_width.value

	s.border_color = fill_border_color.color

	s.corner_radius_top_left = fill_top_left.value
	s.corner_radius_top_right = fill_top_right.value
	s.corner_radius_bottom_right = fill_bottom_right.value
	s.corner_radius_bottom_left = fill_bottom_left.value

	s.expand_margin_left = fill_left_margin.value
	s.expand_margin_top = fill_top_margin.value
	s.expand_margin_right = fill_right_margin.value
	s.expand_margin_bottom = fill_bottom_margin.value

	s.shadow_color = fill_shadow_color.color
	s.shadow_size = fill_shadow_size.value
	s.shadow_offset = Vector2(fill_shadow_offset_x.value, fill_shadow_offset_x.value)

	add_theme_stylebox_override('fill', s)
