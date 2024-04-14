extends Control
## Main menu settings

@onready var right_control = $RightControl

func _on_crosshair_pressed() -> void:
	_hide_options()
	right_control.get_node("Crosshair").visible = true

func _on_video_pressed() -> void:
	_hide_options()
	right_control.get_node("Video").visible = true

func _on_controls_pressed() -> void:
	_hide_options()
	right_control.get_node("Controls").visible = true

func _on_audio_pressed() -> void:
	_hide_options()
	right_control.get_node("Audio").visible = true

## Hide all right panel options
func _hide_options() -> void:
	for child in right_control.get_children():
		child.visible = false
