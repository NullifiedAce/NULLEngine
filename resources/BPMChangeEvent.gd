extends Resource

class_name BPMChangeEvent

var song_time:float = 0.0
var bpm:float = 100.0

static func create(song_time:float, bpm:float):
	var instance:BPMChangeEvent = new()
	instance.song_time = song_time
	instance.bpm = bpm
	return instance
