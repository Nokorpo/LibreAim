extends Control
class_name Audio

const hit_sounds: Dictionary = {
	"beep": "res://scenes/enemies/beep.ogg",
	"bell": "res://scenes/enemies/bell.ogg",
	"kalimba": "res://scenes/enemies/kalimba.ogg",
}

var category := DataManager.categories.SETTINGS

func _ready() -> void:
	category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "volume") != null:
		_set_volume_label()
	var option_button := $OptionButton
	for sound in hit_sounds:
		option_button.add_item(sound)
	if DataManager.get_data(category, "hit_sound") != null:
		var selected = DataManager.get_data(category, "hit_sound")
		for i in range(option_button.item_count):
			if selected == option_button.get_item_text(i):
				option_button.select(i) 

func _on_volume_slider_value_changed(value) -> void:
	DataManager.save_data("volume", value, category)
	_set_volume_label()

func _set_volume_label() -> void:
	var volume_label := $VolumeLabel
	volume_label.text = "Volume " + str(DataManager.get_data(category, "volume"))
	var volume_slider := $VolumeSlider
	volume_slider.value = DataManager.get_data(category, "volume")

func _on_option_button_item_selected(index: int) -> void:
	DataManager.save_data("hit_sound", hit_sounds.keys()[index], category)
	$Preview/AudioStreamPlayer.update_hit_sound()

func _on_preview_pressed() -> void:
	$Preview/AudioStreamPlayer.play()
