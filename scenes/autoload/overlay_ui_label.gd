extends Label

func _process(_delta: float) -> void:
	if SaveManager.settings.get_data("user", "fps_overlay"):
		set_text("FPS " + str(Engine.get_frames_per_second()))
	else:
		set_text("")
