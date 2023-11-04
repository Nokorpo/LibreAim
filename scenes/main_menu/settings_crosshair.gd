extends Control

signal refresh_crosshair

@onready var crosshair = $MarginContainer/VBoxContainer/CrosshairSettings/Preview/Crosshair
@onready var file_export = $MarginContainer/VBoxContainer/ExportFileDialog
@onready var file_import = $MarginContainer/VBoxContainer/ImportFileDialog

var fileImportCallback = null

func _ready():
	if OS.has_feature("web"):
		fileImportCallback = JavaScriptBridge.create_callback(Callable(self, "file_parser"))
		var window = JavaScriptBridge.get_interface("window")
		window.getFile(fileImportCallback)
	file_export.visible = false
	file_import.visible = false
	load_saved()

func _on_crosshair_color_color_changed(color):
	DataManager.save_data("CrosshairColor", str(color))
	emit_signal("refresh_crosshair")

func _on_outline_color_color_changed(color):
	DataManager.save_data("OutlineColor", str(color))
	emit_signal("refresh_crosshair")

func _on_export_pressed():
	if OS.has_feature("web"):
		DataManager.save_all_data_to_file_web()
	else:
		file_export.current_dir = "/"
		set_window(file_export)

func _on_import_pressed():
	if OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		window.input.click()
	else:
		file_import.current_dir = "/"
		set_window(file_import)

func _on_export_file_dialog_file_selected(path):
	DataManager.save_all_data(path)

func _on_import_file_dialog_file_selected(path):
	DataManager.load_all_data(path)
	DataManager.save_all_data()
	emit_signal("refresh_crosshair")

func _on_dot_change_value(value):
	change_value("DotSize", float(value))

func _on_dot_toggle_checkbox(value):
	change_value("Dot", value)

func _on_length_change_value(value):
	change_value("CrosshairLength", float(value))

func _on_thickness_change_value(value):
	change_value("CrosshairThickness", float(value))

func _on_outline_toggle_checkbox(value):
	change_value("Outline", value)

func _on_outline_change_value(value):
	change_value("OutlineSize", float(value))

func _on_gap_change_value(value):
	change_value("CrosshairGap", float(value))

func change_value(key, value):
	DataManager.save_data(key, value)
	emit_signal("refresh_crosshair")

func set_window(window):
	window.visible = true
	window.size = Vector2(800, 800)
	window.position = Vector2(0, 0)

func file_parser(args):
	DataManager.load_all_data_from_param(args[0])

func load_saved():
	var all_persist_groups = get_tree().get_nodes_in_group("Persist")
	for persist_group in all_persist_groups:
		match persist_group.get_class():
			"CheckButton":
				if DataManager.get_data(persist_group.name) != null:
					persist_group.set_pressed(DataManager.get_data(persist_group.name))
			"LineEdit":
				if DataManager.get_data(persist_group.name) != null:
					persist_group.text = str((DataManager.get_data(persist_group.name)))
			"ColorPickerButton":
				if DataManager.get_data(persist_group.name) != null:
					persist_group.color = Global.string_to_color(DataManager.get_data(persist_group.name)) 
			_:
				print("Not loaded")
