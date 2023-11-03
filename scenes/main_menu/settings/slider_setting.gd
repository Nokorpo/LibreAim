@tool
extends Node

signal change_value(value)
signal toggle_checkbox(value)

@export var label_text := "Label":
	set(new_value):
		label_text = new_value
		$Label.text = new_value

@export var max_value := 100:
	set(new_value):
		max_value = new_value
		slider.max_value = new_value

@export var min_value := 0:
	set(new_value):
		min_value = new_value
		slider.min_value = new_value

@export var value := 50.0:
	set(new_value):
		if value > max_value:
			value = max_value
		elif value < min_value:
			value = min_value
		else:
			value = new_value
		
		line_edit.text = str(value)
		slider.value = value
		change_value.emit(new_value)

@export var has_checkbox := true:
	set(value):
		has_checkbox = value

@export var checkbox_value := true:
	set(value):
		checkbox_value = value 

@onready var label = $Label
@onready var line_edit = $LineEdit
@onready var slider = $Slider

func _on_line_edit_text_changed(new_text):
	value = new_text

func _on_slider_value_changed(new_value):
	value = new_value

func _on_check_box_toggled(button_pressed):
	toggle_checkbox.emit(button_pressed)
