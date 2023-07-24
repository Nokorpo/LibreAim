extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var the_new_pause_state = false

#
#func _input(event):
#	if event.is_action_pressed("ui_cancel"):
#		trigger_pause(not get_tree().paused)




func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		trigger_pause(true)

func trigger_pause(new_pause_state):
	the_new_pause_state = new_pause_state
	get_tree().paused = the_new_pause_state
	visible = the_new_pause_state
	if (the_new_pause_state):
		$Buttons/Resume.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_resume_pressed():
	if Global.IS_WEB_EXPORTED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	trigger_pause(false)

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainScreen.tscn")

func _on_player_pause_game(is_paused):
	trigger_pause(is_paused)


