class_name HighScoreManager
## Manages the high scores saved by the user

const PROGRESS_PATH = "user://data/progress/"

static func save_high_score(key: String, value) -> void:
	if is_high_score(key, value):
		SaveManager.highscores.set_data("user", key, value)
	var time_dict: Dictionary = Time.get_datetime_dict_from_system()
	var time_string: String = "%s_%s_%s" % \
		[time_dict.hour, time_dict.minute, time_dict.second]
	
	var cfg_path: String = get_progress_path(Global.current_scenario.id)
	var cfg := ConfigFile.new()
	cfg.load(cfg_path)
	cfg.set_value(Time.get_date_string_from_system(), time_string, value)
	create_folder_if_not_exists(PROGRESS_PATH)
	cfg.save(cfg_path)

static func is_high_score(key: String, value) -> bool:
	return value > get_high_score(key)

static func get_high_score(key: String) -> int:
	return SaveManager.highscores.get_data("user", key, 0)

static func get_progress_path(scenario_id: String) -> String:
	return "user://data/progress/" + scenario_id + ".cfg"

static func create_folder_if_not_exists(folder_path: String) -> void:
	if not DirAccess.dir_exists_absolute(folder_path):
		var err = DirAccess.make_dir_recursive_absolute(folder_path)
		if err != OK:
			push_error("Failed to create directory: %s (Error code: %d)" % [folder_path, err])
