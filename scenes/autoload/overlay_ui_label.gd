extends Label

func _process(_delta: float) -> void:
	if DataManager.get_data(DataManager.categories.SETTINGS, "fps_overlay"):
		set_text("FPS " + str(Engine.get_frames_per_second()))
	else:
		set_text("")

