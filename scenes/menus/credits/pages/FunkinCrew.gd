extends Control

var credits:CreditsJson

@onready var header: Label = $Header
@onready var line: Label = $Line

func _ready() -> void:
	credits = CreditsJson.load_credits()

	load_items()

func load_items():
	for i in credits.entries:
		if i["header"]:
			var new_header = header.duplicate(7)
			var new_seperator = HSeparator.new()
			var new_seperator2 = HSeparator.new()
			new_header.text = " " + i["header"]
			new_header.show()
			add_child(new_seperator)
			add_child(new_header)
			add_child(new_seperator2)
		if i["body"]:
			for l in i["body"]:
				var new_line = line.duplicate(7)
				new_line.text = " " + l["line"]
				new_line.show()
				add_child(new_line)
