extends HBoxContainer
## FPS Overlay settings

@onready var fps_overlay_checkbox = $FPSOverlayCheckBox

func _on_fps_overlay_check_box_toggled(value: bool) -> void:
	DataManager.save_data("fps_overlay", value, DataManager.categories.SETTINGS)

func _ready() -> void:
	var category = DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "fps_overlay"):
		fps_overlay_checkbox.button_pressed = DataManager.get_data(category, "fps_overlay")
