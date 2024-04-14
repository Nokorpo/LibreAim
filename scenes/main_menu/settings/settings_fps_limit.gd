extends VBoxContainer
## FPS limit settings

@onready var fps_limit_slider = $FPSLimitSlider
@onready var fps_limit_label = $FPSLimitLabel

func _on_fps_limit_slider_value_changed(value):
	DataManager.save_data("fps_limit", value, DataManager.categories.SETTINGS)
	DisplayManager.set_max_fps(value)
	update_label()

func _ready():
	var category = DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "fps_limit"):
		fps_limit_slider.value = DataManager.get_data(category, "fps_limit")
	
	update_label()

func update_label() -> void:
	fps_limit_label.text = "FPS Limit: %d fps" % fps_limit_slider.value 
