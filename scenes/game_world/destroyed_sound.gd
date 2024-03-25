extends AudioStreamPlayer

func _ready():
	update_hit_sound()

func _on_volume_updated(_value: float):
	update_hit_sound()

func update_hit_sound():
	var volume = DataManager.get_data(DataManager.categories.SETTINGS, "volume")
	if volume != null:
		var this_bus = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(this_bus, lerpf(-20, 0, volume))
		AudioServer.set_bus_mute(this_bus, volume == 0)
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "hit_sound") != null:
		var selected = DataManager.get_data(category, "hit_sound")
		stream = load(Audio.hit_sounds[selected])

