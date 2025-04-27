class_name SettingsAudio
extends Control
## Audio settings

@onready var option_button := $OptionButton

func _ready() -> void:
	_set_volume_label()
	_add_destroy_sounds(option_button)
	_set_selected_sound_index()

func _add_destroy_sounds(options_button: OptionButton):
	var i = 0
	for path:String in Global.get_destroy_sounds():
		options_button.add_item(path.get_file(), i)
		options_button.set_item_metadata(i, path)
		i += 1

func _on_volume_slider_value_changed(value) -> void:
	SaveManager.settings.set_data("user", "volume", value)
	_set_volume_label()

func _set_volume_label() -> void:
	var volume_label := $VolumeLabel
	volume_label.text = "Volume " + str(SaveManager.settings.get_data("audio", "volume"))
	var volume_slider := $VolumeSlider
	volume_slider.value = SaveManager.settings.get_data("audio", "volume")

func _on_option_button_item_selected(index: int) -> void:
	SaveManager.settings.set_data("audio", "hit_sound", option_button.get_item_metadata(index))
	$Preview/AudioStreamPlayer.update_hit_sound()

func _on_preview_pressed() -> void:
	$Preview/AudioStreamPlayer.play()

func _set_selected_sound_index() -> void:
	var selected = SaveManager.settings.get_data("audio", "hit_sound")
	for i in range(option_button.item_count):
		if selected == option_button.get_item_metadata(i):
			option_button.select(i)
