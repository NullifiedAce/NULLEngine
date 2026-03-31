extends Resource
class_name CharacterData

var is_animated:bool = true
var is_player:bool = false

var can_sing:bool = true

var sing_duration:float = 4.0

var dances:bool = true
var dance_steps:Array = ["idle"]

var combo_anims:Dictionary = {}

var health_icon:String = "res://assets/images/gameplay/icons/icon-face.png"
var health_icon_scale:float = 1.0
var health_icon_filter:int = 0
var health_icon_frames:int = 2
var health_color:String = "FFFFFF"

var death_character:String = "bf-dead"
var death_sound:String = "res://assets/sounds/death/fnf_loss_sfx.ogg"
var death_music:String = "res://assets/music/gameOver.ogg"
var retry_sound:String = "res://assets/music/gameOverEnd.ogg"

var voices_path:String = "dad"
var character_script_path:String = ""
var character_script_name:String = ""

var scale:float = 1.0
var filter:int = 0

var flip_h:bool = false
var flip_v:bool = false

var sprite_frames:Array = []
var anim_data:Array = []

static func load_data(character:String):
	if ResourceLoader.exists("res://assets/data/characters/"+character+".json"):
		var json = JSON.parse_string(FileAccess.open("res://assets/data/characters/"+character+".json", FileAccess.READ).get_as_text())
		return load_from_json(json)
	else:
		var json = JSON.parse_string(FileAccess.open("res://assets/data/characters/bf.json", FileAccess.READ).get_as_text())
		return load_from_json(json)

static func load_from_json(json):
	var data = new()

	if "is_animated" in json:
		data.is_animated = json.is_animated
	if "is_player" in json:
		data.is_player = json.is_player

	if "can_sing" in json:
		data.can_sing = json.can_sing

	if "sing_duration" in json:
		data.sing_duration = json.sing_duration

	if "dances" in json:
		data.dances = json.dances
	if "dance_steps" in json:
		data.dance_steps = json.dance_steps

	if "combo_anims" in json:
		data.combo_anims = json.combo_anims

	if "health_icon" in json:
		data.health_icon = json.health_icon
	if "health_icon_scale" in json:
		data.health_icon_scale = json.health_icon_scale
	if "health_icon_filter" in json:
		data.health_icon_filter = json.health_icon_filter
	if "health_icon_frames" in json:
		data.health_icon_frames = json.health_icon_frames
	if "health_color" in json:
		data.health_color = json.health_color

	if "death_character" in json:
		data.death_character = json.death_character
	if "death_sound" in json:
		data.death_sound = json.death_sound
	if "death_music" in json:
		data.death_music = json.death_music
	if "retry_sound" in json:
		data.retry_sound = json.retry_sound

	if "voices_path" in json:
		data.voices_path = json.voices_path
	if "character_script_path" in json:
		data.character_script_path = json.character_script_path
	if "character_script_name" in json:
		data.character_script_name = json.character_script_name

	if "scale" in json:
		data.scale = json.scale
	if "filter" in json:
		data.filter = json.filter

	if "flip_h" in json:
		data.flip_h = json.flip_h
	if "flip_v" in json:
		data.flip_v = json.flip_v

	if "sprite_frames" in json:
		data.sprite_frames = json.sprite_frames
	if "anim_data" in json:
		data.anim_data = json.anim_data

	return data
