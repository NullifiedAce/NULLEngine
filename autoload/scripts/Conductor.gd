extends Node

var rate:float = 1.0
var bpm:float = 100.0

var crochet:float = ((60.0 / bpm) * 1000.0) # beats in milliseconds
var step_crochet:float = crochet / 4.0 # steps in milliseconds

var position:float = 0.0

var safe_frames:int = 10
var safe_zone_offset:float = (safe_frames / 60.0) * 1000.0

var cur_beat:int = 0
var cur_step:int = 0
var cur_section:int = 0

var cur_dec_beat:float = 0
var cur_dec_step:float = 0
var cur_dec_section:float = 0

var numerator:int = 4
var denominator:int = 4

# i am so fucking happy you can make arrays of custom resources now
var bpm_change_map:Array[BPMChangeEvent] = []

signal beat_hit(beat:int)
signal step_hit(step:int)
signal section_hit(section:int)

func map_bpm_changes(meta:Metadata):
	bpm_change_map = []

	for i in meta.timeChanges.size():
		var event:BPMChangeEvent = BPMChangeEvent.create(meta.timeChanges[i]["t"], meta.timeChanges[i]["bpm"])
		bpm_change_map.append(event)

func change_bpm(new:float):
	bpm = new
	crochet = ((60.0 / new) * 1000.0)
	step_crochet = crochet / 4.0

func _process(delta):
	var old_step:int = cur_step
	var old_beat:int = cur_beat
	var old_section:int = cur_section

	var last_change:BPMChangeEvent = BPMChangeEvent.create(0, 0)
	var highest_pos:float = 0
	for i in bpm_change_map:
		if position > i["song_time"] and i["song_time"] > highest_pos:
			highest_pos = i["song_time"]
			last_change = i

	if last_change.bpm != 0: change_bpm(last_change.bpm)

	cur_step = floor((position - last_change.song_time) / step_crochet)
	cur_beat = floor(cur_step / numerator)
	cur_section = floor(cur_step / (numerator * denominator))

	cur_dec_step = ((position - last_change.song_time) / step_crochet)
	cur_dec_beat = cur_dec_step / numerator
	cur_dec_section = cur_dec_step / (numerator * denominator)

	if old_step != cur_step && cur_step > 0: step_hit.emit(cur_step)
	if old_beat != cur_beat && cur_beat > 0: beat_hit.emit(cur_beat)
	if old_section != cur_section && cur_section > 0: section_hit.emit(cur_section)

func is_sound_synced(sound:AudioStreamPlayer):
	# i love windows
	var ms_allowed:float = (30 if OS.get_name() == "Windows" else 20) * sound.pitch_scale
	var sound_time:float = sound.get_playback_position() * 1000.0
	return !(absf(sound_time - position) > ms_allowed)
