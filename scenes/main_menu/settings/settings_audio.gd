extends Control
class_name Audio
## Audio settings

const hit_sounds: Dictionary = {
	"beep": "res://scenes/enemies/beep.ogg",
	"bell": "res://scenes/enemies/bell.ogg",
	"kalimba": "res://scenes/enemies/kalimba.ogg",
}

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "audio")

func _ready() -> void:
	_set_volume_label()
	var option_button := $OptionButton
	for sound in hit_sounds:
		option_button.add_item(sound)
	var selected = data_wrapper.get_data("hit_sound")
	for i in range(option_button.item_count):
		if selected == option_button.get_item_text(i):
			option_button.select(i)

func _on_volume_slider_value_changed(value) -> void:
	data_wrapper.set_data("volume", value)
	_set_volume_label()

func _set_volume_label() -> void:
	var volume_label := $VolumeLabel
	volume_label.text = "Volume " + str(data_wrapper.get_data("volume"))
	var volume_slider := $VolumeSlider
	volume_slider.value = data_wrapper.get_data("volume")

func _on_option_button_item_selected(index: int) -> void:
	data_wrapper.set_data("hit_sound", hit_sounds.keys()[index])
	$Preview/AudioStreamPlayer.update_hit_sound()

func _on_preview_pressed() -> void:
	$Preview/AudioStreamPlayer.play()
