extends Button
class_name HUDTextButton

var output_text:String

@onready var delete: Button = $Delete
@onready var move_down: Button = $MoveDown
@onready var move_up: Button = $MoveUp
@onready var window: Window = $Window

@onready var output_text_label: Label = $OutputTextLabel

@onready var default_text: TextEdit = $Window/ScrollContainer/VBoxContainer/TextBoxes/DefaultText
@onready var text_prefix: TextEdit = $Window/ScrollContainer/VBoxContainer/TextBoxes/TextPrefix
@onready var text_suffix: TextEdit = $Window/ScrollContainer/VBoxContainer/TextBoxes/TextSuffix

@onready var track_value_box: CheckBox = $Window/ScrollContainer/VBoxContainer/Values/TrackValueBox
@onready var track_value: OptionButton = $Window/ScrollContainer/VBoxContainer/Values/TrackValue

var parent

func _ready() -> void:
	parent = get_label()

	delete.pressed.connect(func():
		queue_free())
	move_down.pressed.connect(func():
		parent.move_child_down(self))
	move_up.pressed.connect(func():
		parent.move_child_up(self))
	pressed.connect(func():
		if window.visible: window.hide()
		else: window.show())

func get_label(): # this fucking shitpiss bruh
	return get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().hud_label # this fucking shit bruh

func _process(delta: float) -> void:
	default_text.visible = not track_value_box.button_pressed
	text_prefix.visible = track_value_box.button_pressed
	text_suffix.visible = track_value_box.button_pressed

	update_output()

func update_output():
	if !track_value_box.button_pressed:
		output_text = default_text.text
	else:
		output_text = text_prefix.text + "0" + text_suffix.text

	output_text_label.text = output_text
