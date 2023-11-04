@tool
extends Node

signal change_value(value)
signal toggle_checkbox(value)

@export var label_text := "Label":
	set(new_value):
		label_text = new_value
		$Label.text = new_value

@export var max_value: float = 100:
	set(new_value):
		max_value = new_value
		$Slider.max_value = new_value

@export var min_value: float = 0:
	set(new_value):
		min_value = new_value
		$Slider.min_value = new_value

@export var value: float = 50.0:
	set(new_value):
		if value > max_value:
			value = max_value
		elif value < min_value:
			value = min_value
		else:
			value = new_value
		
		$SpinBox.value = value
		$Slider.value = value
		change_value.emit(new_value)

@export var has_checkbox := true:
	set(value):
		has_checkbox = value
		$CheckBox.visible = has_checkbox

@export var checkbox_value := true:
	set(value):
		checkbox_value = value
		$CheckBox.button_pressed = value

@onready var slider = $Slider

func _on_spin_box_value_changed(new_value):
	value = new_value

func _on_slider_value_changed(new_value):
	value = new_value

func _on_check_box_toggled(button_pressed):
	toggle_checkbox.emit(button_pressed)
