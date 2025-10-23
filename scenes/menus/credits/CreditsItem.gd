extends Control
class_name CreditsItem

@export var jpeg:bool = false
@export var avatar_url:String ## Set a URL to an image to show it here.
@export var credit_name:String
@export_multiline var credits_description:String

@onready var pfp: TextureRect = $PFP
@onready var name_label: Label = $Name
@onready var description: Label = $Description

func _ready():
	name_label.text = credit_name
	description.text = credits_description

func load_pfp():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(avatar_url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
		return

	var image = Image.new()
	var error = image.load_png_from_buffer(body) if !jpeg else image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	# Display the image in a TextureRect node.
	pfp.texture = texture
