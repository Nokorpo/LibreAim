extends AudioStreamPlayer
## Sound played on target destroyed

func _ready() -> void:
	update_hit_sound()

func _on_volume_updated(_value: float) -> void:
	update_hit_sound()

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "audio")

func update_hit_sound() -> void:
	var volume = data_wrapper.get_data("volume")
	if volume != null:
		var this_bus := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(this_bus, lerpf(-20, 0, volume))
		AudioServer.set_bus_mute(this_bus, volume == 0)
	var selected = data_wrapper.get_data("hit_sound")
	stream = load(Audio.hit_sounds[selected])
