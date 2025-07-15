class_name EditorRuler extends Control

@export var is_horizontal := true
@export var spacing := 32 # grid unit in world space
@export var major_tick := 128
@export var zoom := 1.0
@export var offset := Vector2.ZERO

var font : Font

func _ready():
	font = get_theme_default_font()

func _draw():
	var size = get_size()
	var length = size.x if is_horizontal else size.y
	
	# Camera origin in world space
	var camera_offset = offset
	var start = -offset.x if is_horizontal else -offset.y
	
	var tick_step = spacing * zoom
	var major_step = major_tick * zoom
	var start_pixel = fmod(start, tick_step)

	for i in range(int(length / tick_step) + 2):
		var pos = start_pixel + i * tick_step
		var label_value = int((pos - start) / zoom)

		if is_horizontal:
			# draw vertical tick
			var height = 10 if int(label_value) % major_tick != 0 else 20
			draw_line(Vector2(pos, 0), Vector2(pos, height), Color.WHITE)
			if int(label_value) % major_tick == 0:
				draw_string(font, Vector2(pos + 2, height + 10), str(label_value), HORIZONTAL_ALIGNMENT_LEFT, -1, 12.0)
		else:
			# draw horizontal tick
			var width = 10 if int(label_value) % major_tick != 0 else 20
			draw_line(Vector2(0, pos), Vector2(width, pos), Color.WHITE)
			if int(label_value) % major_tick == 0:
				draw_string(font, Vector2(width + 2, pos + 4), str(label_value), HORIZONTAL_ALIGNMENT_LEFT, -1, 12.0)

func update_ruler(_zoom: float, _offset: Vector2):
	zoom = _zoom
	offset = _offset
	queue_redraw()
