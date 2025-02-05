extends Resource
class_name TrophyItem

@export_group("Data")
@export var id:String = "FF"
@export var title:String = "Funkin'"
@export_multiline var description:String = "Start the game."
@export var starts_locked:bool = false
@export_group("Look")
@export_enum("Bronze", "Silver", "Gold", "Platinum") var rarity:int = 0
@export var particles:bool = false
@export var amount:float = 8
