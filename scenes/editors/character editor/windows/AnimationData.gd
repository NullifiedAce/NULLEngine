extends Window

var animation_data:Array

@onready var add_anim: Button = $AddAnim
@onready var anim_group: VBoxContainer = $Anims/AnimGroup

@onready var anim_name: TextEdit = $AnimData/AnimName
@onready var anim_data_name: TextEdit = $AnimData/AnimDataName
@onready var frame: SpinBox = $AnimData/Frame
@onready var offset_x: SpinBox = $AnimData/HBoxContainer/OffsetX
@onready var offset_y: SpinBox = $AnimData/HBoxContainer/OffsetY
@onready var sprite_frame: SpinBox = $AnimData/SpriteFrame

func _ready() -> void:
	setup_signals()

func setup_signals():
	add_anim.pressed.connect(add_animation)

func load_data(character_data: CharacterData):
	animation_data = character_data.anim_data

	for i in animation_data:
		add_animation(i)

func add_animation(anim_data:Array = []):
	var anim:Button = Button.new()
	var delete_button:Button = Button.new()

	delete_button.custom_minimum_size = Vector2.ONE*32
	delete_button.text = "x"

	delete_button.pressed.connect(func():
		anim.queue_free()
	)

	delete_button.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	delete_button.position.x -= 16

	if anim_data.size() > 0: anim.text = anim_data[0]
	anim.custom_minimum_size.y = 32
	anim.alignment = HORIZONTAL_ALIGNMENT_LEFT

	anim.add_child(delete_button)
	anim_group.add_child(anim)
