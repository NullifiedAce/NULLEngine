extends Camera2D
class_name EditorCamera

var mouse_start_pos
var screen_start_position

var dragging = false

@export var default_cam_zoom:float = 1.05

func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = (mouse_start_pos - event.position) + screen_start_position

	if event.is_action_pressed("cam_zoom_in"):
		zoom = zoom + Vector2(0.1, 0.1)

	if event.is_action_pressed("cam_zoom_out"):
		zoom = clamp(zoom - Vector2(0.1, 0.1), Vector2(0.1, 0.1), zoom)

	if event.is_action_pressed("cam_reset"):
		position = Global.game_size / 2
		zoom = Vector2(default_cam_zoom, default_cam_zoom)
