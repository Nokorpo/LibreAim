extends Control

@onready var control_2 = $HBoxContainer/Control2

func _on_crosshair_pressed():
	hide_options()
	$HBoxContainer/Control2/Crosshair.visible = true

func _on_video_pressed():
	hide_options()
	$HBoxContainer/Control2/Video.visible = true

func _on_controls_pressed():
	hide_options()
	$HBoxContainer/Control2/Controls.visible = true

func hide_options():
	for child in control_2.get_children():
		child.visible = false
