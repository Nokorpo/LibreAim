extends Control

signal refresh_crosshair

@onready var crosshair = $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/Crosshair

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(crosshair.is_pressed())
#	crosshair.set_pressed(true)
	loadSaved()
	var all_put_labels = get_tree().get_nodes_in_group("PutLabel")
	for put_label in all_put_labels:
		putLabel(put_label)

func putLabel(put_label):
	var label = Label.new()
	var hbox = HBoxContainer.new()
	label.text = put_label.name + ': '
	hbox.add_child(label)
	var parent = put_label.get_parent()
	var index = put_label.get_index()
	parent.remove_child(put_label)
	hbox.add_child(put_label)
	parent.add_child(hbox)
	parent.move_child(hbox, index)


func loadSaved():
	var all_persist_groups = get_tree().get_nodes_in_group("Persist")
	for persist_group in all_persist_groups:
		print(persist_group.name)
		match persist_group.get_class():
			"CheckButton":
				if DataManager.get_data(persist_group.name) != null:
					persist_group.set_pressed(DataManager.get_data(persist_group.name))
			"LineEdit":
				if DataManager.get_data(persist_group.name) != null:
					persist_group.text = str((DataManager.get_data(persist_group.name)))
			_:
				print("Not loaded")
		

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainScreen.tscn")


func _on_crosshair_toggled(button_pressed):
	DataManager.save_data("Crosshair", button_pressed)
	emit_signal("refresh_crosshair")


func _on_outline_toggled(button_pressed):
	DataManager.save_data("Outline", button_pressed)
	emit_signal("refresh_crosshair")


func _on_crosshair_inner_toggled(button_pressed):
	DataManager.save_data("CrosshairInner", button_pressed)
	emit_signal("refresh_crosshair")


func _on_dot_toggled(button_pressed):
	DataManager.save_data("Dot", button_pressed)
	emit_signal("refresh_crosshair")


func _on_dot_size_text_changed(new_text):
	DataManager.save_data("DotSize", float(new_text))
	emit_signal("refresh_crosshair")


func _on_outline_size_text_changed(new_text):
	DataManager.save_data("OutlineSize", float(new_text))
	emit_signal("refresh_crosshair")


func _on_crosshair_height_text_changed(new_text):
	DataManager.save_data("CrosshairHeight", float(new_text))
	emit_signal("refresh_crosshair")


func _on_crosshair_width_text_changed(new_text):
	DataManager.save_data("CrosshairWidth", float(new_text))
	emit_signal("refresh_crosshair")


func _on_crosshair_space_text_changed(new_text):
	DataManager.save_data("CrosshairSpace", float(new_text))
	emit_signal("refresh_crosshair")


func _on_refresh_crosshair():
	pass # Replace with function body.
