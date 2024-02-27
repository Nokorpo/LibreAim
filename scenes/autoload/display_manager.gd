extends Node

signal window_mode_updated(window_mode: DisplayServer.WindowMode)

func _ready():
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "window_mode"):
		var selected = DataManager.get_data(category, "window_mode")
		set_window_mode(get_window_mode_from_string(selected))

func _input(event):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			set_window_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			set_window_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_window_mode_from_string(window_mode: String):
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

func set_window_mode(window_mode: DisplayServer.WindowMode):
	window_mode_updated.emit(window_mode)
	DisplayServer.window_set_mode(window_mode)
	if window_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DataManager.save_data("window_mode", "fullscreen", DataManager.categories.SETTINGS)
	elif window_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DataManager.save_data("window_mode", "windowed", DataManager.categories.SETTINGS)
