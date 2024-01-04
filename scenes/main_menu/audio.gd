extends Control

@onready var volume_label = $MarginContainer/VBoxContainer/VolumeLabel
@onready var volume_slider = $MarginContainer/VBoxContainer/VolumeSlider

func _ready():
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "volume") != null:
		set_volume_label()

func _on_volume_slider_value_changed(value):
	var category = DataManager.categories.SETTINGS
	DataManager.save_data("volume", value, category)
	set_volume_label()

func set_volume_label():
	var category = DataManager.categories.SETTINGS
	volume_label.text = "Volume " + str(DataManager.get_data(category, "volume"))
	volume_slider.value = DataManager.get_data(category, "volume")
