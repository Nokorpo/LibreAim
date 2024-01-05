extends Control
class_name Audio

const hit_sounds: Dictionary = {
	"beep": "res://scenes/enemies/beep.ogg",
	"bell": "res://scenes/enemies/bell.ogg",
	"kalimba": "res://scenes/enemies/kalimba.ogg",
}

@onready var volume_label = $MarginContainer/VBoxContainer/VolumeLabel
@onready var volume_slider = $MarginContainer/VBoxContainer/VolumeSlider
@onready var option_button = $MarginContainer/VBoxContainer/OptionButton
var category = DataManager.categories.SETTINGS

func _ready():
	category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "volume") != null:
		set_volume_label()
	for sound in hit_sounds:
		option_button.add_item(sound)
	if DataManager.get_data(category, "hit_sound") != null:
		var selected = DataManager.get_data(category, "hit_sound")
		for i in range(option_button.item_count):
			if selected == option_button.get_item_text(i):
				option_button.select(i) 

func _on_volume_slider_value_changed(value):
	DataManager.save_data("volume", value, category)
	set_volume_label()

func set_volume_label():
	volume_label.text = "Volume " + str(DataManager.get_data(category, "volume"))
	volume_slider.value = DataManager.get_data(category, "volume")

func _on_option_button_item_selected(index):
	DataManager.save_data("hit_sound", hit_sounds.keys()[index], category)
	$MarginContainer/VBoxContainer/Preview/AudioStreamPlayer.update_hit_sound()

func _on_preview_pressed():
	$MarginContainer/VBoxContainer/Preview/AudioStreamPlayer.play()
