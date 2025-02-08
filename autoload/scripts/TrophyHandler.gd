extends Node

var trophies:Dictionary = {
	"BT": false, "BT_0": false,
	"B1": false, "B1_0": false,
	"B2": false, "B2_0": false,
	"B3": false, "B3_0": false,
	"B4": false, "B4_0": false,
	"B5": false, "B5_0": false,
	"B6": false, "B6_0": false,
	"B7": false, "B7_0": false,
	"B8": false, "B8_0": false,
}

var trophy_ids:Array[String] = [
	"BT", "BT_0",
	"B1", "B1_0",
	"B2", "B2_0",
	"B3", "B3_0",
	"B4", "B4_0",
	"B5", "B5_0",
	"B6", "B6_0",
	"B7", "B7_0",
	"B8", "B8_0"
]

var cfg_file = ConfigFile.new()

@export var trophies_array:Array[TrophyItem]

@onready var bg: Panel = $BG
@onready var trophy: Control = $BG/Trophy
@onready var animation: AnimationPlayer = $BG/Trophy/Animation
@onready var particles: CPUParticles2D = $BG/Trophy/Particles
@onready var title: Label = $BG/title

signal trophy_unlocked

func _ready() -> void:
	if !FileAccess.file_exists("user://trophies.cfg"):
		setup_cfg()

	bg.modulate = Color.TRANSPARENT
	load_cfg()

func setup_cfg():
	for i in trophies:
		cfg_file.set_value("Trophy", i, trophies[i])
		cfg_file.save("user://trophies.cfg")

func load_cfg():
	var err = cfg_file.load("user://trophies.cfg")

	if err != OK:
		return

	for i in trophies:
		if cfg_file.has_section_key("Trophy", i):
			trophies[i] = cfg_file.get_value("Trophy", i)
		else:
			print("Trophy \"%s\" does not exist in data file, creating data now." % i)
			cfg_file.set_value("Trophy", i, trophies[i])
			cfg_file.save("user://trophies.cfg")

func save_trophy(trophy_id:String, value:bool):
	if trophies.has(trophy_id): # Make sure the trophy even exists in the dictionary
		cfg_file.set_value("Trophy", trophy_id, value)
		cfg_file.save("user://trophies.cfg")

func get_trophy(trophy_id:String):
	if trophies.has(trophy_id):
		print(trophies[trophy_id])
		return trophies[trophy_id]
	else:
		return false
		print("Trophy \"%s\" does not exist, have you wrote the ID correctly?" % trophy_id)

func unlock_trophy(trophy_id:String):
	if !trophies.has(trophy_id): return

	if trophies[trophy_id] == false:
		for i in trophies_array.size():
			if trophies_array[i].id == trophy_id:
				title.text = trophies_array[i].title
				$BG/Trophy/Sprite.frame = trophies_array[i].rarity
				particles.amount = trophies_array[i].amount
				particles.emitting = trophies_array[i].particles

		var t:Tween = create_tween()
		t.tween_property(bg, "modulate", Color.WHITE, 0.1)
		await t.finished
		t.kill()

		animation.play("unlock")
		save_trophy(trophy_id, true)
		trophies[trophy_id] = true
		await animation.animation_finished
		var t_2:Tween = create_tween()
		t_2.tween_property(bg, "modulate", Color.TRANSPARENT, 0.1)
		await t_2.finished
		t_2.kill()
		emit_signal('trophy_unlocked')
	else:
		await get_tree().create_timer(0.1).timeout # this somehow needs a fucking delay to work
		emit_signal('trophy_unlocked')
