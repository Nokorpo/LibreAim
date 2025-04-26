extends Node

const USER_PATH: String = "user://custom_resources/"
const DEFAULT_PATH :String = "res://assets/default_data/custom_resources/"

## Returns full paths with USER_PATH or DEFAULT_PATH already included
## If 'extension' argument is empty, will ignore extensions entirely
func get_file_list(partial_path: String, extension: String = "", include_default: bool = true) -> PackedStringArray:
	var full_path := USER_PATH + partial_path
	DirAccess.make_dir_recursive_absolute(full_path)
	var list := _get_file_list_raw(full_path, extension)
	if include_default:
		list = get_default_file_list(partial_path, extension) + list
	return list

func get_folder_list(partial_path: String, include_default: bool = true) -> PackedStringArray:
	var full_path := USER_PATH + partial_path
	DirAccess.make_dir_recursive_absolute(full_path)
	var list := _get_folder_list_raw(full_path)
	if include_default:
		list = get_default_folder_list(partial_path) + list
	return list

## Returns full paths with DEFAULT_PATH already included
## If 'extension' argument is empty, will ignore extensions entirely
func get_default_file_list(partial_path: String, extension: String = "") -> PackedStringArray:
	var full_path := DEFAULT_PATH + partial_path
	return _get_file_list_raw(full_path, extension)

func get_default_folder_list(partial_path: String) -> PackedStringArray:
	var full_path := DEFAULT_PATH + partial_path
	return _get_folder_list_raw(full_path)

func file_exists(path: String) -> bool:
	var partial_path := _ensure_path_is_partial(path)
	var default_path := DEFAULT_PATH + partial_path
	if FileAccess.file_exists(default_path):
		return true
	var user_path := USER_PATH + partial_path
	if FileAccess.file_exists(user_path):
		return true
	return false

func get_image(full_path: String) -> Texture2D:
	if full_path.begins_with(DEFAULT_PATH):
		return load(full_path)
	var image := Image.load_from_file(full_path)
	return ImageTexture.create_from_image(image)

func get_sound(full_path: String) -> AudioStream:
	if full_path.begins_with(DEFAULT_PATH):
		return load(full_path)
	return AudioStreamOggVorbis.load_from_file(full_path)

func _ensure_path_is_partial(path :String) -> String:
	if path.begins_with(USER_PATH):
		return path.right(-USER_PATH.length())
	elif path.begins_with(DEFAULT_PATH):
		return path.right(-DEFAULT_PATH.length())
	return path

func _get_folder_list_raw(full_path: String) -> PackedStringArray:
	var list := PackedStringArray()
	var dir = DirAccess.open(full_path)
	if dir == null:
		return list
	for dir_name: String in dir.get_directories():
		var path := full_path + "/" + dir_name + "/"
		list.append(path)
	return list

func _get_file_list_raw(full_path: String, extension: String) -> PackedStringArray:
	var list := PackedStringArray()
	var dir = DirAccess.open(full_path)
	if dir == null:
		return list
	
	var is_default := full_path.begins_with(DEFAULT_PATH)
	# runs in editor produce duplicates because it has both .import and original file
	var duplicate_checks := {}
	
	for file_name: String in dir.get_files():
		if is_default and file_name.get_extension() == "import":
			file_name = file_name.replace('.import', '')
		if _extension_matches(file_name, extension):
			var path := full_path + "/" + file_name
			if duplicate_checks.has(path):
				continue
			list.append(path)
			duplicate_checks[path] = true
	
	return list

func _extension_matches(path: String, extension: String) -> bool:
	if extension == "":
		return true
	return path.get_extension() == extension
