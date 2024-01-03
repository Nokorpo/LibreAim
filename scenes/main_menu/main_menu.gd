extends Control

@onready var panel := $HBoxContainer/Panel
@onready var exit_button = $HBoxContainer/MarginContainer/VBoxContainer/Quit

func _ready() -> void:
	hide_options()
	if OS.has_feature("web"):
		exit_button.visible = false

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
