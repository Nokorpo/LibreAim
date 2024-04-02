extends HBoxContainer

@onready var fps_overlay_checkbox = $FPSOverlayCheckBox

func _on_fps_overlay_check_box_toggled(value: bool):
	DataManager.save_data("fps_overlay", value, DataManager.categories.SETTINGS)

func _ready() :
	var category = DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "fps_limit"):
		fps_overlay_checkbox.button_pressed = DataManager.get_data(category, "fps_overlay")
