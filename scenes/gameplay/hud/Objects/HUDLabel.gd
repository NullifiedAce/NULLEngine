class_name HUDEditorLabel extends Label

var hud_editor:HUDEditor

var drag:bool = false
var mouse_pressed:bool = false
var mouse_hovered:bool = false

@onready var pos_box_x: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Position/PositionX
@onready var pos_box_y: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Position/PositionY
@onready var rot_box: SpinBox = $EditWindow/ScrollContainer/VBoxContainer/Rotation


func _ready() -> void:
	if get_parent().get_parent() is HUDEditor: # Check if the node we're looking for is the HUD Editor.
		hud_editor = get_parent().get_parent()
	else:
		printerr(str(get_parent().get_parent())+" is not class \"HUDEditor\".")

	mouse_entered.connect(func(): mouse_hovered = true)
	mouse_exited.connect(func(): mouse_hovered = false if !mouse_pressed else true)

func _process(delta: float) -> void:
	if !drag: position = Vector2(pos_box_x.value, pos_box_y.value)
	rotation = deg_to_rad(rot_box.value)

	drag = mouse_hovered and mouse_pressed

func _input(event: InputEvent) -> void:
	if event.is_action("drag"):
		if event.is_pressed(): mouse_pressed = true
		else: mouse_pressed = false
	elif event is InputEventMouseMotion and drag:
		position = get_viewport().get_mouse_position()
		pos_box_x.value = position.x
		pos_box_y.value = position.y
