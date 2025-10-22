extends FunkinScript

var cocked:bool = false

func on_player_hit(note:Note):
	if note.note_type == "weekend-1-cockgun":
		cocked = true

	if note.note_type == "weekend-1-firegun":
		if cocked:
			game.player.play_anim("shoot", true, true)
			Audio.play_sound("weekend1/shot"+str(randi_range(1, 4)))
		else:
			game.player.play_anim("hit", true, true)

func on_player_miss(note:Note):
	if note.note_type == "weekend-1-cockgun":
		cocked = false

	if note.note_type == "weekend-1-firegun":
		game.player.play_anim("hit", true, true)
