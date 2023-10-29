extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		trigger_pause(true)

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		trigger_pause(true)

func trigger_pause(new_pause_state):
	get_tree().paused = new_pause_state
	$Pause.visible = new_pause_state
	if (new_pause_state):
		$Pause/Buttons/Resume.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	trigger_pause(false)

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
