class_name HighScoreManager
## Manages the high scores saved by the user

static func save_high_score(key: String, value) -> void:
	if is_high_score(key, value):
		SaveManager.highscores.set_data("user", key, value)
	var time_dict: Dictionary = Time.get_datetime_dict_from_system()
	var time_string: String = "%s_%s_%s" % \
		[time_dict.hour, time_dict.minute, time_dict.second]
	
	var cfg_path: String = get_progress_path(Global.current_gamemode.id)
	var cfg := ConfigFile.new()
	cfg.load(cfg_path)
	cfg.set_value(Time.get_date_string_from_system(), time_string, value)
	cfg.save(cfg_path)

static func is_high_score(key: String, value) -> bool:
	return value > get_high_score(key)

static func get_high_score(key: String) -> int:
	return SaveManager.highscores.get_data("user", key, 0)

static func get_progress_path(gamemode_id: String) -> String:
	return "user://data/progress/" + gamemode_id + ".cfg"
