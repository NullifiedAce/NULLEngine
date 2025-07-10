extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false

@export var zoom_speed = 0.05
@export var min_zoom = 0.5
@export var max_zoom = 3.0

func _input(event):
	#if event.is_action("drag"):
		#if event.is_pressed():
			#mouse_start_pos = event.position
			#screen_start_position = position
			#dragging = true
		#else:
			#dragging = false
	#elif event is InputEventMouseMotion and dragging:
		#position = zoom * (mouse_start_pos - event.position) + screen_start_position

	if event.is_action_pressed("cam_zoom_in"):
		zoom.x = max(min_zoom, zoom.x - zoom_speed)
		zoom.y = max(min_zoom, zoom.y - zoom_speed)
	elif event.is_action_pressed("cam_zoom_out"):
		zoom.x = min(max_zoom, zoom.x + zoom_speed)
		zoom.y = min(max_zoom, zoom.y + zoom_speed)

	if event.is_action_pressed("cam_reset"):
		position = Vector2(640, 360)
		zoom = Vector2.ONE
