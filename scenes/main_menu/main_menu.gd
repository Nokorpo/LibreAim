extends Control
## Main menu manager

@onready var right_panel := $HBoxContainer/RightPanel

func _ready() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer/Play.grab_focus()
	_hide_options()

func _on_play_pressed() -> void:
	_hide_options()
	right_panel.get_node("SelectGamemode").visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	_hide_options()
	right_panel.get_node("Settings").visible = true

func _on_source_code_pressed() -> void:
	OS.shell_open("https://github.com/antimundo/libre-aim") 

## Hide all right panel options
func _hide_options() -> void:
	for child in right_panel.get_children():
		child.visible = false 
