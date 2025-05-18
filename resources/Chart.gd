extends Resource
class_name Chart

var notes:Array[SongNote] = []
var events:Array[SongEvent] = []
var scroll_speed:float = 1.0

static func load_chart(song:String, difficulty:String = "normal", variation:String = "default"):
	var json = JSON.parse_string(FileAccess.open("res://assets/songs/"+song.to_lower()+"/chart-"+variation+".json", FileAccess.READ).get_as_text())
	return load_from_json(json, difficulty)

static func load_from_json(json, difficulty:String):
	var chart = new()

	if difficulty in json.scrollSpeed:
		chart.scroll_speed = json.scrollSpeed[difficulty]
	else :
		chart.scroll_speed = json.scrollSpeed["default"]

	# oh god wish me luck converting these
	# damn base game chart files are so good

	if "events" in json:
		for event in json.events:
			var new_event:SongEvent = SongEvent.new()
			new_event.time = event["t"]
			new_event.name = event["e"]
			new_event.parameters = event["v"]

			chart.events.append(new_event)

	for note in json.notes[difficulty]:
		var new_note:SongNote = SongNote.new()
		new_note.time = float(note["t"])
		new_note.direction = int(note["d"])
		if "l" in note:
			new_note.length = float(note["l"])
		else:
			new_note.length = 0.0

		if "k" in note:
			new_note.kind = str(note["k"])
		else:
			new_note.kind = "default"

		chart.notes.append(new_note)

	return chart
