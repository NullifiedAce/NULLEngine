extends Cutscene
@onready var video = $video

func _ready():
	if OS.get_name() == "macOS": # Skip video cutscenes as they don't work correctly on MacOS.
		_end()
	video.finished.connect(_end)
	video.play()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		_end()
