extends Node
class_name Metadata

var version:String = "1.0.0"

var timeFormat:String = "ms"

var artist:String = "Kawai Sprite"
var charter:String = "ninjamuffin99"

var rawSongName:String = "bopeebo"
var songName:String = "Bopeebo"

var timeChanges: Array = [{ "t": 0, "bpm": 100, "n": 4, "d": 4, "bt": [4, 4, 4, 4] }]

var offsets: Dictionary = {
	"instrumental": 0,
	"altInstrumentals": {},
	"vocals": {},
	"altVocals": {}
}

var playData: Dictionary = {
	"stage": "stage",
	"characters": {
		"player": "bf",
		"girlfriend": "gf",
		"opponent": "dad",
		"altInstrumentals": ["pico"]
	},
	"song variations": ["erect", "pico"],
	"difficulty": ["easy", "normal", "hard"],
	"ratings": { "easy": 1, "normal": 2, "hard": 3 },
	"noteStyle": "funkin",
	"album": "volume1",
	"previewStart": 0,
	"previewEnd": 15000
}


static func load_metadata(song:String, variation:String = "default"):
	var json = JSON.parse_string(FileAccess.open("res://assets/songs/"+song.to_lower()+"/metadata-"+variation+".json", FileAccess.READ).get_as_text())
	return load_from_json(song, json)

static func load_from_json(song:String, json):
	var metadata = new()

	metadata.version = json.version
	metadata.timeFormat = json.timeFormat
	metadata.artist = json.artist
	metadata.charter = json.charter
	metadata.rawSongName = json.rawSongName
	metadata.songName = json.songName
	metadata.timeChanges = json.timeChanges
	if json.has("offsets"):
		metadata.offsets = json.offsets
	metadata.playData = json.playData

	return metadata
