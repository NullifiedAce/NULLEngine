extends Control

@export var vu_count: int = 3
@export var bar_height: int = 80
@export var freq_max: float = 11050.0
@export var min_db: float = 80.0

@onready var spectrum = AudioServer.get_bus_effect_instance(1,0)

@onready var vizArea = get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var prev_hz = 0

	for i in range(1,vu_count+1):
		var hz = i * freq_max / vu_count;
		var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
		var energy = clamp((min_db + linear_to_db(f.length()))/min_db,0,1)
		var height = energy * bar_height

		prev_hz = hz

		var viz = vizArea[i - 1]

		var tween = get_tree().create_tween()

		tween.tween_property(viz, "value", height * 1.1, 0.05)
