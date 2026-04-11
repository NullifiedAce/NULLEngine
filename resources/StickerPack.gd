class_name StickerPack extends Resource

@export var id:String
@export var stickers:Array[Texture2D]

func get_random_sticker(last:bool):
	return stickers.get(randi_range(0, stickers.size()-1))
