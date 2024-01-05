extends AudioStreamPlayer

func _ready():
	var volume = DataManager.get_data(DataManager.categories.SETTINGS, "volume")
	if volume != null:
		var this_bus = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(this_bus, lerpf(-20, 0, volume))
		AudioServer.set_bus_mute(this_bus, volume == 0)
	update_hit_sound()

func update_hit_sound():
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "hit_sound") != null:
		var selected = DataManager.get_data(category, "hit_sound")
		stream = load(Audio.hit_sounds[selected])
