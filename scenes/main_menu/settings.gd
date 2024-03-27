extends Control
###

@onready var control_2 = $HBoxContainer/Control2

func _on_crosshair_pressed() -> void:
	_hide_options()
	control_2.get_node("Crosshair").visible = true

func _on_video_pressed() -> void:
	_hide_options()
	control_2.get_node("Video").visible = true

func _on_controls_pressed() -> void:
	_hide_options()
	control_2.get_node("Controls").visible = true

func _on_audio_pressed() -> void:
	_hide_options()
	control_2.get_node("Audio").visible = true

## Hide all right panel options
func _hide_options() -> void:
	for child in control_2.get_children():
		child.visible = false
