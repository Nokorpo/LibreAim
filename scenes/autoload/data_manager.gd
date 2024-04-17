extends Node

const USER_PATH: String = "user://data/"
const FORMAT: String = "cfg"
const DEFAULT_PATH :String = "res://default_data/"

const SETTINGS_FILE_PATH := "settings"
const HIGHSCORE_FILE_PATH := "highscores"
const HIGHSCORE_SECTION := "user"
const LOAD_ON_READY_PATHS := [SETTINGS_FILE_PATH, HIGHSCORE_FILE_PATH]

var default_data :Dictionary = {}
var file_data: Dictionary = {}
var pending_file_changes :Dictionary = {}

## save changes to disk at the end of current update frame
var auto_apply_changes := true

class SectionWrapper:
	var file_path:String
	var section:String
	func set_data(key: String, value: Variant):
		DataManager.set_data(file_path, section, key, value)
	func get_data(key: String, default: Variant = null) -> Variant:
		return DataManager.get_data(file_path, section, key, default)
	func get_keys() -> PackedStringArray:
		return DataManager.get_config(file_path).get_section_keys(section)

func _ready() -> void:
	for file_path in LOAD_ON_READY_PATHS:
		get_config(file_path)

func get_wrapper(file_path: String, section: String) -> SectionWrapper:
	var wrapper := SectionWrapper.new()
	wrapper.file_path = file_path
	wrapper.section = section
	return wrapper

func get_config(file_path: String) -> ConfigFile:
	if not file_data.has(file_path):
		file_data[file_path] = load_file(file_path)
	return file_data[file_path]

func set_data(file_path: String, section: String, key: String, value: Variant):
	var config := get_config(file_path)
	config.set_value(section, key, value)
	pending_file_changes[file_path] = true
	if auto_apply_changes and not get_tree().process_frame.is_connected(save_pending):
		get_tree().process_frame.connect(save_pending, CONNECT_ONE_SHOT)

func get_data(file_path: String, section: String, key :String, default :Variant = null) -> Variant:
	var config := get_config(file_path)
	return config.get_value(section, key, default)

# there's no reason to use this, but it's good to have it for completeness
func save_all_data() -> void:
	for file_path in file_data:
		save_file(file_path)
	pending_file_changes.clear()

func save_pending():
	for file_path in pending_file_changes:
		save_file(file_path)
	pending_file_changes.clear()

func cancel_pending():
	for file_path in pending_file_changes:
		load_file(file_path)
	pending_file_changes.clear()

func save_file(file_path:String):
	if not file_data.has(file_path):
		push_error("Data file does not exist: %s"%file_path)
		return
	var config := get_config(file_path)
	var full_path := USER_PATH + file_path + "."+FORMAT
	DirAccess.make_dir_recursive_absolute(full_path.get_base_dir())
	var res := config.save(full_path)
	assert(res == OK, "Error saving data: %s path: %s"%[res, full_path])

func load_file(file_path: String) -> ConfigFile:
	var config := ConfigFile.new()
	config.load(USER_PATH + file_path + "."+FORMAT)
	
	var default_path := DEFAULT_PATH + file_path + ".gd"
	if ResourceLoader.exists(default_path):
		var script := load(default_path) as Script
		var defaultConfig := ConfigFile.new()
		var err := defaultConfig.parse(script.data)
		if err == OK:
			for section in defaultConfig.get_sections():
				for key in defaultConfig.get_section_keys(section):
					if config.has_section_key(section, key):
						continue
					var val = defaultConfig.get_value(section, key)
					config.set_value(section, key, val)
	else:
		print("default does not exist: %s"%default_path)
	
	return config

# these are old functions
# i made them function and left it here for now to minimize changes
# probably should be moved?


func save_high_score(key: String, value) -> void:
	if is_high_score(key, value):
		set_data(HIGHSCORE_FILE_PATH, HIGHSCORE_SECTION, key, value)

func is_high_score(key: String, value) -> bool:
	return value > get_high_score(key)

func get_high_score(key: String) -> int:
	return get_data(HIGHSCORE_FILE_PATH, HIGHSCORE_SECTION, key, 0)

