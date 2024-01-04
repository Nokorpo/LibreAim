extends AudioStreamPlayer

func _ready():
	var volume = DataManager.get_data(DataManager.categories.SETTINGS, "volume")
	if volume != null:
		var this_bus = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(this_bus, lerpf(-20, 0, volume))
		AudioServer.set_bus_mute(this_bus, volume == 0)
