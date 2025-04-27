extends Node
## Manages the application window

signal window_mode_updated(window_mode: DisplayServer.WindowMode)

func _ready() -> void:
	var selected = SaveManager.settings.get_data("video", "window_mode")
	set_window_mode(get_window_mode_from_string(selected))
	set_max_fps(SaveManager.settings.get_data("video", "fps_limit"))

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
		SaveManager.settings.set_data("video", "window_mode", "fullscreen")
	elif window_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		SaveManager.settings.set_data("video", "window_mode", "windowed")

func set_max_fps(value) -> void:
	Engine.set_max_fps(value)
