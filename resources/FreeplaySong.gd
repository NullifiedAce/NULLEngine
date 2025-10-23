extends Resource
class_name FreeplaySong

@export var song:String = "test"
@export var display_name:String = ""
@export var character_icon:CompressedTexture2D = preload("res://assets/images/gameplay/icons/icon-face.png")
@export var icon_frames:int = 2
@export var icon_scale:float = 1.0
@export_range(0, 1, 1) var icon_filter = 0

@export var difficulties:Array[String] = ["easy", "normal", "hard"]
@export var bg_color:Color = Color.WHITE
