extends Resource
class_name CreditsJson

var entries:Array = []

static func load_credits():
	var json = JSON.parse_string(FileAccess.open("res://assets/data/credits.json", FileAccess.READ).get_as_text())
	return load_from_json(json)

static func load_from_json(json):
	var credits = CreditsJson.new()

	for i in json["entries"]:
		credits.entries.append(i)

	return credits
