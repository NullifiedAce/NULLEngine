extends Event

var scroll:float = 1.0
var duration:float = 4.0
var trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
var ease_type: Tween.EaseType = Tween.EASE_IN
var absolute:bool = false
var strumline:String = "both" # this does not work yet :3
var instant:bool = false

func _ready():
	if parameters.has("scroll"): scroll = parameters["scroll"]
	if parameters.has("duration"): duration = parameters["duration"]
	if parameters.has("ease"):
		if !parameters["ease"] == "INSTANT":
			var ease_data = Global.parse_ease(parameters["ease"])
			print(ease_data)
			trans_type = ease_data.trans_type
			ease_type = ease_data.ease_type
		else: instant = true
	if parameters.has("strumline"): strumline = parameters["strumline"]
	if parameters.has("absolute"): absolute = parameters["absolute"]

	if instant:
		game.scroll_speed = scroll
	else:
		var durSeconds = Conductor.step_crochet*duration/1000

		game.tween_scroll_speed(scroll, durSeconds, trans_type, ease_type)
