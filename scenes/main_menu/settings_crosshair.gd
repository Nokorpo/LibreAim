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
	change_value("dot_size", float(value))

func _on_dot_toggle_checkbox(value):
	change_value("dot", value)

func _on_length_change_value(value):
	change_value("crosshair_length", float(value))

func _on_thickness_change_value(value):
	change_value("crosshair_thickness", float(value))

func _on_outline_toggle_checkbox(value):
	change_value("outline_enable", value)

func _on_outline_change_value(value):
	change_value("outline_width", float(value))

func _on_gap_change_value(value):
	change_value("crosshair_gap", float(value))

func _on_crosshair_color_color_changed(color):
	change_value("color", str(color))

func _on_outline_color_color_changed(color):
	change_value("outline_color", str(color))
	
func change_value(key, value):
	DataManager.save_data(key, value, DataManager.categories.CROSSHAIR)
	emit_signal("refresh_crosshair")

func set_window(window):
	window.visible = true
	window.size = Vector2(800, 800)
	window.position = Vector2(0, 0)

func file_parser(args):
	DataManager.load_all_data_from_param(args[0])

func load_saved():
	var categories = DataManager.categories.CROSSHAIR
	if DataManager.get_data(categories, "dot") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Dot.checkbox_value \
			= DataManager.get_data(categories, "dot")
	if DataManager.get_data(categories, "dot_size") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Dot.value \
			= DataManager.get_data(categories, "dot_size")
	if DataManager.get_data(categories, "crosshair_length") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Length.value \
			= DataManager.get_data(categories, "crosshair_length")
	if DataManager.get_data(categories, "crosshair_thickness") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Thickness.value \
			= DataManager.get_data(categories, "crosshair_thickness")
	if DataManager.get_data(categories, "crosshair_gap") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Gap.value \
			= DataManager.get_data(categories, "crosshair_gap")
	if DataManager.get_data(categories, "outline_enable") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Outline.checkbox_value \
			= DataManager.get_data(categories, "outline_enable")
	if DataManager.get_data(categories, "outline_width") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Outline.value \
			= DataManager.get_data(categories, "outline_width")
	if DataManager.get_data(categories, "color") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/Color/CrosshairColor.color \
			= Global.string_to_color(DataManager.get_data(categories, "color"))
	if DataManager.get_data(categories, "outline_color") != null:
		$MarginContainer/VBoxContainer/CrosshairSettings/OutlineColor/OutlineColor.color \
			= Global.string_to_color(DataManager.get_data(categories, "outline_color"))
