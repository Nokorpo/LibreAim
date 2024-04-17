extends VBoxContainer
## FPS limit settings

@onready var fps_limit_slider = $FPSLimitSlider
@onready var fps_limit_label = $FPSLimitLabel

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "video")

func _on_fps_limit_slider_value_changed(value):
	data_wrapper.set_data("fps_limit", value)
	DisplayManager.set_max_fps(value)
	update_label()

func _ready():
	fps_limit_slider.value = data_wrapper.get_data("fps_limit")
	
	update_label()

func update_label() -> void:
	fps_limit_label.text = "FPS Limit: %d fps" % fps_limit_slider.value 
