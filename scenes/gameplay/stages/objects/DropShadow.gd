extends Node2D

var target: Character

@export_enum("Player", "Opponent", "Spectator") var character := 0
@export var alt_mask: Texture2D
@export var stage: Stage

@onready var shader: ShaderMaterial = material

func _ready() -> void:
	shader.set_shader_parameter("alt_mask", alt_mask)

func _process(_delta: float) -> void:
	if !stage.game:
		return

	match character:
		0: target = stage.game.player
		1: target = stage.game.opponent
		2: target = stage.game.spectator

	if !target:
		return

	var anim_sprite: AnimatedSprite2D = target.anim_sprite
	if anim_sprite == null:
		return

	var frames := anim_sprite.sprite_frames
	var anim := anim_sprite.animation
	var frame := anim_sprite.frame
	var tex: Texture2D = frames.get_frame_texture(anim, frame)
	if tex == null:
		return

	# Always refresh mask
	shader.set_shader_parameter("alt_mask", alt_mask)

	# Determine UV bounds for current frame
	if tex is AtlasTexture:
		var atlas_tex: Texture2D = tex.get_atlas()
		var region: Rect2 = tex.get_region()
		var atlas_size: Vector2 = atlas_tex.get_size()

		# These are the normalized UVs of this frame within the atlas
		var left   = region.position.x / atlas_size.x
		var top    = region.position.y / atlas_size.y
		var right  = (region.position.x + region.size.x) / atlas_size.x
		var bottom = (region.position.y + region.size.y) / atlas_size.y

		# Optional: if your sprite sheet Y is flipped vertically, swap top/bottom
		# var tmp = top; top = bottom; bottom = tmp

		shader.set_shader_parameter("u_frame_bounds", Vector4(left, top, right, bottom))
	else:
		shader.set_shader_parameter("u_frame_bounds", Vector4(0.0, 0.0, 1.0, 1.0))
