extends AudioStreamPlayer
## Sound played on target destroyed

func _ready() -> void:
	update_hit_sound()

func _on_volume_updated(_value: float) -> void:
	update_hit_sound()

func update_hit_sound() -> void:
	var volume = SaveManager.settings.get_data("audio", "volume")
	if volume != null:
		var this_bus := AudioServer.get_bus_index("Master")
		AudioServer.set_bus_volume_db(this_bus, lerpf(-20, 0, volume))
		AudioServer.set_bus_mute(this_bus, volume == 0)	
	stream = Global.get_current_hit_sound()
