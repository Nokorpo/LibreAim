extends Control

@onready var full_screen_needed = $"../FullScreenRequest"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#
#func _input(event):
#	if event.is_action_pressed("ui_cancel"):
#		trigger_pause(not get_tree().paused)

func _process(_delta):
	if Input.is_action_pressed("f_pressed"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		is_already_full_screen()

func is_already_full_screen():
	if !(DisplayServer.window_get_mode() < 3):
		full_screen_needed.visible = false

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		trigger_pause(true)

func trigger_pause(new_pause_state):
	get_tree().paused = new_pause_state
	visible = new_pause_state
	if (new_pause_state):
		$Buttons/Resume.grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _on_resume_pressed():
	trigger_pause(false)

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainScreen.tscn")

func _on_player_pause_game():
	trigger_pause(true)


