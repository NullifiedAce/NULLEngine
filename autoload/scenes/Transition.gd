extends CanvasLayer

var transitioning:bool = false

var cur_sticker:StickerSprite

var sticker_sounds:Array[String] = [
	"stickersounds/keyClick1",
	"stickersounds/keyClick2",
	"stickersounds/keyClick3",
	"stickersounds/keyClick4",
	"stickersounds/keyClick5",
	"stickersounds/keyClick7",
	"stickersounds/keyClick8",
	"stickersounds/keyClick9"
]

@onready var anim_player:AnimationPlayer = $TextureRect/AnimationPlayer
@onready var stickers_grp: CanvasGroup = $Stickers

@export var stickers:Dictionary[String, StickerPack]

func regen_stickers(path:String):
	transitioning = true

	if stickers_grp.get_child_count() > 0:
		for i in stickers_grp.get_children(): i.queue_free()

	var x_pos:float = -100.0
	var y_pos:float = -100.0

	while x_pos <= Global.game_size.x:
		var sticker:StickerSprite = StickerSprite.new()
		sticker.texture = stickers["default-bf"].get_random_sticker(false)

		sticker.visible = false
		sticker.position = Vector2(x_pos, y_pos)
		x_pos += sticker.texture.get_width() * 0.5
		if x_pos >= Global.game_size.x:
			if y_pos <= Global.game_size.y:
				x_pos = -100
				y_pos += randf_range(70, 120)

		sticker.rotation_degrees = randi_range(-60, 70)
		stickers_grp.add_child(sticker)
	shuffle_stickers(stickers_grp)

	var last_sticker:StickerSprite = StickerSprite.new()
	last_sticker.texture = stickers["default"].get_random_sticker(true)
	last_sticker.visible = false
	last_sticker.position = Global.game_size/2
	stickers_grp.add_child(last_sticker)

	for ind in stickers_grp.get_child_count():
		var sticker:StickerSprite = stickers_grp.get_child(ind)
		sticker.timing = remap(ind, 0, stickers_grp.get_child_count(), 0, 0.9)
		cur_sticker = sticker
		get_tree().create_timer(sticker.timing).timeout.connect(func():
			sticker.visible = true
			Audio.play_sound(sticker_sounds.get(randi_range(0, sticker_sounds.size()-1)))
			
			var frame_timer_val:int = randi_range(1, 2)

			if ind == stickers_grp.get_child_count(): frame_timer_val = 2
			get_tree().create_timer((1.0/24.0) * frame_timer_val).timeout.connect(func():
				sticker.scale = Vector2(randf_range(0.97, 1.02), randf_range(0.97, 1.02))

				if ind == stickers_grp.get_child_count()-1:
					Global.finish_switch_scene(path)
			)
		)

func degen_stickers():
	for ind in stickers_grp.get_child_count():
		var sticker:StickerSprite = stickers_grp.get_child(ind)
		get_tree().create_timer(sticker.timing).timeout.connect(func():
			sticker.visible = false
			Audio.play_sound(sticker_sounds.get(randi_range(0, sticker_sounds.size()-1)))
			
			sticker.queue_free()

			if ind == stickers_grp.get_child_count()-1:
				transitioning = false
		)

func shuffle_stickers(node: Node):
	var children := node.get_children()
	children.shuffle()
	for i in children.size():
		node.move_child(children[i], i)
