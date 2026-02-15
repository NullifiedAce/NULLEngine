extends AnimatedSprite2D
class_name CharacterNode

var special_anim:bool = false
var anim_timer:float = 0.0

var last_anim:String = "_"
var cur_dance_step:int = 0

var hold_timer:float = 0.0
var anim_finished:bool = false

var _is_true_player:bool = false
var dance_on_beat:bool = true

var initial_size:Vector2 = Vector2.ZERO

var camera_pos:Node2D

var data:CharacterData

@onready var game: Gameplay = $"../.." # The node has to be placed in the characters Node2D group.

func _ready() -> void:
	speed_scale = Conductor.rate

	connect("animation_finished", func(): anim_finished = true)
	dance(true)

	if sprite_frames:
		initial_size = Vector2(
			sprite_frames.get_frame_texture(animation, 0).get_width(),
			sprite_frames.get_frame_texture(animation, 0).get_height()
		)

	position.x -= initial_size.x/2
	position.y -= initial_size.y

	camera_pos = Node2D.new()
	add_child(camera_pos)
	camera_pos.position = ((initial_size / 2) * scale) # Set camera position to the middle of the character.

	if data.is_player != _is_true_player:
		scale.x *= -1

func _process(delta):
	if anim_timer > 0.0:
		anim_timer -= delta
		if anim_timer <= 0.0:
			if special_anim and last_anim == 'hey' or last_anim == 'cheer':
				special_anim = false
				dance()

			anim_timer = 0.0
	elif special_anim and anim_finished:
		special_anim = false
		dance()

	if last_anim.begins_with("sing"):
		hold_timer += delta * Conductor.rate
		if not _is_true_player and hold_timer >= Conductor.step_crochet * data.sing_duration * 0.0011:
			hold_timer = 0.0
			dance()

func play_anim(anim:String, force:bool = false, special:bool = false):
	if not data.is_animated: return
	if "sing" in anim and not data.can_sing: return

	special_anim = special

	# swap left and right anims
	if data.is_player != _is_true_player:
		if anim == "singLEFT":
			anim = "singRIGHT"
		elif anim == "singRIGHT":
			anim = "singLEFT"
		elif anim == "singLEFT-alt":
			anim = "singRIGHT-alt"
		elif anim == "singRIGHT-alt":
			anim = "singLEFT-alt"

	if force or last_anim != anim or anim_finished or last_anim.contains("-loop"):
		sprite_frames = load(data.sprite_frames[get_anim_sprite_frame(anim)])

		if last_anim == anim:
			frame = get_anim_frame(anim)

		last_anim = anim
		anim_finished = false

		offset = get_anim_offset(anim)
		play(get_anim_name(anim))

func dance(force:bool = false):
	if special_anim and not force or !data.dances:
		return

	play_anim(data.dance_steps[cur_dance_step], force)

	cur_dance_step += 1
	if cur_dance_step > data.dance_steps.size() - 1:
		cur_dance_step = 0

func get_anim_name(anim:String):
	var anim_name:String

	for i in data.anim_data:
		if i[0] == anim:
			anim_name = i[1]

	return anim_name

func get_anim_frame(anim:String):
	var anim_frame:int

	for i in data.anim_data:
		if i[0] == anim:
			anim_frame = i[2]

	return anim_frame

func get_anim_sprite_frame(anim:String):
	var sprite_frame:float

	for i in data.anim_data:
		if i[0] == anim:
			sprite_frame = i[5]

	return sprite_frame

func get_anim_offset(anim:String):
	var anim_offset:Vector2

	for i in data.anim_data:
		if i[0] == anim:
			anim_offset = Vector2(i[3], i[4])

	return anim_offset
