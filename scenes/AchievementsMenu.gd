extends MusicBeatScene

@onready var description: Label = $CenterRef/Description
@onready var trophy_container: HBoxContainer = $CenterRef/HBoxContainer

var cur_selected:int = 0
var last_selected:int = 0
var is_scrolling:bool = false

func _ready() -> void:
	for trophy in TrophyHandler.trophies_array.size():
		var trophy_node = load("res://scenes/achievements/Trophy.tscn").instantiate()

		trophy_node.trophy = TrophyHandler.trophies_array[trophy].rarity
		trophy_node.particles_emitting = TrophyHandler.trophies_array[trophy].particles
		trophy_node.particles_amount = TrophyHandler.trophies_array[trophy].amount

		trophy_node.trophy_id = TrophyHandler.trophies_array[trophy].id
		trophy_node.trophy_title = TrophyHandler.trophies_array[trophy].title
		trophy_node.trophy_description = TrophyHandler.trophies_array[trophy].description
		trophy_node.trophy_hidden = TrophyHandler.trophies_array[trophy].starts_locked

		trophy_node.name = TrophyHandler.trophies_array[trophy].id
		trophy_node.unlocked = TrophyHandler.get_trophy(TrophyHandler.trophies_array[trophy].id)
		trophy_container.add_child(trophy_node)

	change_selection()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("cancelMenu")
		Global.switch_scene("res://scenes/MainMenu.tscn")
	if Input.is_action_just_pressed("ui_right") and !is_scrolling:
		change_selection(1)
	if Input.is_action_just_pressed("ui_left") and !is_scrolling:
		change_selection(-1)

func change_selection(change:int = 0):
	cur_selected = wrapi(cur_selected + change, 0, TrophyHandler.trophies_array.size())
	is_scrolling = true

	var final_x = trophy_container.position.x - (384 * change)

	var t:Tween = create_tween()
	if cur_selected == TrophyHandler.trophies_array.size() - 1 and last_selected == 0:
		t.tween_property(trophy_container, "position:x", -5952, 0.25)
	elif cur_selected == 0 and last_selected == TrophyHandler.trophies_array.size() - 1:
		t.tween_property(trophy_container, "position:x", 576, 0.25)
	else:
		t.tween_property(trophy_container, "position:x", final_x, 0.25)

	description.text = TrophyHandler.trophies_array[cur_selected].description if !TrophyHandler.trophies_array[cur_selected].starts_locked else "Unlock this trophy to see its description."

	Audio.play_sound("scrollMenu")
	await t.finished
	last_selected = cur_selected
	is_scrolling = false
	t.kill()
