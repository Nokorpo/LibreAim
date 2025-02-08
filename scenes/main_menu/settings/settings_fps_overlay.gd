extends HBoxContainer
## FPS Overlay settings

@onready var fps_overlay_checkbox = $FPSOverlayCheckBox

func _on_fps_overlay_check_box_toggled(value: bool) -> void:
	SaveManager.settings.set_data("user", "fps_overlay", value)

func _ready() -> void:
	fps_overlay_checkbox.set_pressed_no_signal(SaveManager.settings.get_data("user", "fps_overlay"))
