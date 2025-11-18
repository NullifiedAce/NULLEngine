extends Resource
class_name OptionItem

enum OptionVariant {
	TEXT,
	BOOL, 
	FLOAT, 
	INT,
	MENU,
	BIND,
	STRING
}

enum BindType {
	STANDARD,
	ALT
}

@export var option_name:String
@export_multiline var option_description:String
@export var option_key:String
@export var option_variant:OptionVariant = OptionVariant.TEXT
@export_group("Numeric Values")
@export var numeric_min:float
@export var numeric_max:float = INF
@export var numeric_step:float = 1.0
@export var numeric_value_multiplier:float = 1.0
@export var numeric_suffix:String
@export_group("Bind Values")
@export var bind_type:BindType = BindType.STANDARD
@export_group("String Values")
@export var string_array:Array[String]
