extends Control

@onready var panel := $HBoxContainer/Panel
@onready var exit_button = $HBoxContainer/MarginContainer/VBoxContainer/Quit

func _ready():
	hide_options()
	if OS.has_feature("web"):
		exit_button.visible = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_play_pressed():
	hide_options()
	$HBoxContainer/Panel/SelectLevel.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	hide_options()
	$HBoxContainer/Panel/Settings.visible = true
	
func _on_source_code_pressed():
	OS.shell_open("https://github.com/antimundo/OpenAimTrainer") 
	
func hide_options():
	for child in panel.get_children():
		child.visible = false
