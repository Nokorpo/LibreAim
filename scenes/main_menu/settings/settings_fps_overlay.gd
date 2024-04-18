extends HBoxContainer
## FPS Overlay settings

@onready var fps_overlay_checkbox = $FPSOverlayCheckBox

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "user")

func _on_fps_overlay_check_box_toggled(value: bool) -> void:
	data_wrapper.set_data("fps_overlay", value)

func _ready() -> void:
	fps_overlay_checkbox.set_pressed_no_signal(data_wrapper.get_data("fps_overlay"))
