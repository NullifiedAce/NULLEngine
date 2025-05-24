extends CanvasLayer

var user_authenticated: bool = false

@onready var gamejolt_api: GameJoltAPI = $GameJoltAPI
@onready var username_box: LineEdit = $LogIn/ScrollContainer/VBoxContainer/Username/Username
@onready var token_box: LineEdit = $LogIn/ScrollContainer/VBoxContainer/GameToken/GameToken
@onready var login_button: Button = $LogIn/ScrollContainer/VBoxContainer/Buttons/LogIn

func _ready() -> void: # Connect the signals to the methods in ready.
	login_button.pressed.connect(_on_login_pressed)
	gamejolt_api.gamejolt_request_completed.connect(_on_gamejolt_request_completed)

func _on_login_pressed() -> void:
	gamejolt_api.user_auth(username_box.text, token_box.text)
	login_button.disabled = true

func _on_gamejolt_request_completed(request_type, response) -> void:
	match request_type:
		'/users/auth/':
			user_authenticated = response['success']
			if user_authenticated:
				pass # Add code for when the user is authenticated.
			else:
				pass # Add code for when the user fails to authenticate.
			login_button.disabled = false
		# Use a match statement so you can add more request_types later
