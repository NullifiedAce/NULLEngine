extends Node

func _ready() -> void:
	DiscordRPC.app_id = 1264652502700134400
	DiscordRPC.large_image = "logo"
	DiscordRPC.large_image_text = "NULL Engine v" + ProjectSettings.get_setting("application/config/version")

	DiscordRPC.refresh()

func set_text(details: String, state: String):
	DiscordRPC.details = details
	DiscordRPC.state = state
	DiscordRPC.refresh()

func set_large_img(img: String, text: String):
	DiscordRPC.large_image = img
	DiscordRPC.large_image_text = text
	DiscordRPC.refresh()

func set_small_img(img: String, text: String):
	DiscordRPC.small_image = img
	DiscordRPC.small_image_text = text
	DiscordRPC.refresh()

func start_timestamp():
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh()
