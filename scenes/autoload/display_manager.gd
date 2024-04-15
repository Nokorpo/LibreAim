extends Node

signal window_mode_updated(window_mode: DisplayServer.WindowMode)

func _ready() -> void:
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "window_mode"):
		var selected = DataManager.get_data(category, "window_mode")
		set_window_mode(get_window_mode_from_string(selected))
	var fps_limit = 120
	if DataManager.get_data(category, "fps_limit"):
		fps_limit = int(DataManager.get_data(category, "fps_limit"))
	set_max_fps(fps_limit)

func _input(event) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			set_window_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			set_window_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_window_mode_from_string(window_mode: String) -> void:
	set_window_mode(get_window_mode_from_string(window_mode))

func get_window_mode_from_string(window_mode: String):
	match window_mode:
		"fullscreen":
			return DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		"windowed":
			return DisplayServer.WINDOW_MODE_MAXIMIZED
	return null

func get_string_from_window_mode(window_mode: DisplayServer.WindowMode):
	match window_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			return "fullscreen"
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			return "windowed"
	return null

func set_window_mode(window_mode: DisplayServer.WindowMode) -> void:
	window_mode_updated.emit(window_mode)
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DataManager.save_data("window_mode", "fullscreen", DataManager.categories.SETTINGS)
	elif window_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DataManager.save_data("window_mode", "windowed", DataManager.categories.SETTINGS)

func set_max_fps(value) -> void:
	Engine.set_max_fps(value)
