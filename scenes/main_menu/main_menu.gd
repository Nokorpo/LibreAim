extends Control
## Main menu manager

@onready var _right_panel := $RightControl

func _ready() -> void:
	$LeftControl/VBoxContainer/Play.grab_focus()
	_hide_options()

func _on_play_pressed() -> void:
	_hide_options()
	_right_panel.get_node("SelectScenario").visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	_hide_options()
	_right_panel.get_node("Settings").visible = true

func _on_source_code_pressed() -> void:
	OS.shell_open("https://github.com/Nokorpo/LibreAim") 

func _on_user_folder_pressed():
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://"))

## Hide all right panel options
func _hide_options() -> void:
	for child in _right_panel.get_children():
		child.visible = false 
