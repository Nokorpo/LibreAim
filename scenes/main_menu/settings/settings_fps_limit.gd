extends VBoxContainer
## FPS limit settings

@onready var fps_limit_slider = $FPSLimitSlider
@onready var fps_limit_label = $FPSLimitLabel

func _on_fps_limit_slider_value_changed(value) -> void:
	SaveManager.settings.set_data("video", "fps_limit", value)
	DisplayManager.set_max_fps(value)
	update_label()

func _ready() -> void:
	fps_limit_slider.value = SaveManager.settings.get_data("video", "fps_limit")
	
	update_label()

func update_label() -> void:
	fps_limit_label.text = "FPS Limit: %d fps" % fps_limit_slider.value 
