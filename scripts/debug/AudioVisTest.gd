extends Control

#@onready
#var spectrum = AudioServer.get_bus_effect_instance(1,0)
#
#@onready var vizArea = $CircleBase.get_children()
#
#@onready var right = $CircleBase/Right.get_children()
#@onready var left = $CircleBase/left.get_children()
#
#const VU_COUNT = 7
#const HEIGHT = 80
#const FREQ_MAX = 11050.0
#
#const MIN_DB = 80
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
	#var prev_hz = 0
#
	#if right:
		#for i in range(1,3+1):
			#var hz = i * FREQ_MAX / VU_COUNT;
			#var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
			#var energy = clamp((MIN_DB + linear_to_db(f.length()))/MIN_DB,0,1)
			#var height = energy * HEIGHT
#
			#prev_hz = hz
#
			#var viz = right[i - 1]
#
			#var tween = get_tree().create_tween()
#
			#tween.tween_property(viz, "value", height * 1.1, 0.05)
	#if left:
		#for i in range(1,3+1):
			#var hz = i * FREQ_MAX / VU_COUNT;
			#var f = spectrum.get_magnitude_for_frequency_range(prev_hz,hz)
			#var energy = clamp((MIN_DB + linear_to_db(f.length()))/MIN_DB,0,1)
			#var height = energy * HEIGHT
#
			#prev_hz = hz
#
			#var viz = right[i - 1]
#
			#var tween = get_tree().create_tween()
#
			#tween.tween_property(viz, "value", height * 1.1, 0.05)
