extends Node

var path: String = "user://" + "V" + ProjectSettings.get_setting("application/config/version") + "/"

var prev_ver:String = "1.0.1"

var show_message: bool = false

func _ready() -> void:
	if !DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_absolute(path)

	if Global.game_version != prev_ver:
		show_message = true

func copy_old_save(old_path: String):
	var dir_acc = DirAccess.open(old_path)
	if dir_acc == null:
		print("Failed to open old save folder: ", old_path)
		return

	# Ensure the new save folder exists
	DirAccess.make_dir_absolute(path)

	# Define blacklist (folders/files that shouldn't be copied)
	var blacklist = ["HUDPresets", "logs", "shader_cache", "vulkan", "V1.1.0"]  # Add whatever you want to skip

	# Copy files recursively while respecting the blacklist
	copy_directory(old_path, path, blacklist)

func copy_directory(src: String, dst: String, blacklist: Array):
	var dir_acc = DirAccess.open(src)
	if dir_acc == null:
		print("Failed to access directory: ", src)
		return

	# Create the destination folder if it doesn't exist
	DirAccess.make_dir_absolute(dst)

	# Iterate over files and copy them
	dir_acc.list_dir_begin()
	var file_name = dir_acc.get_next()
	while file_name != "":
		# Skip blacklisted files/folders
		if file_name in blacklist:
			print("Skipping: ", file_name)
			file_name = dir_acc.get_next()
			continue

		var src_path = src.path_join(file_name)
		var dst_path = dst.path_join(file_name)

		if dir_acc.current_is_dir():
			# Recursively copy subdirectories
			copy_directory(src_path, dst_path, blacklist)
		else:
			# Copy file
			DirAccess.copy_absolute(src_path, dst_path)

		file_name = dir_acc.get_next()
