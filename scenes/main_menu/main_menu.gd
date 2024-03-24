extends Control

@onready var panel := $HBoxContainer/Panel

func _ready() -> void:
	$HBoxContainer/MarginContainer/VBoxContainer/Play.grab_focus()
	hide_options()

func _on_play_pressed() -> void:
	hide_options()
	$HBoxContainer/Panel/SelectLevel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	hide_options()
	$HBoxContainer/Panel/Settings.visible = true

func _on_source_code_pressed() -> void:
	OS.shell_open("https://github.com/antimundo/libre-aim") 

func hide_options() -> void:
	for child in panel.get_children():
		child.visible = false
