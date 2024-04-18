extends Node

signal window_mode_updated(window_mode: DisplayServer.WindowMode)

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "video")

func _ready() -> void:
	var selected = data_wrapper.get_data("window_mode")
	set_window_mode(get_window_mode_from_string(selected))
	set_max_fps( data_wrapper.get_data("fps_limit") )

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
		data_wrapper.set_data("window_mode", "fullscreen")
	elif window_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		data_wrapper.set_data("window_mode", "windowed")

func set_max_fps(value) -> void:
	Engine.set_max_fps(value)
