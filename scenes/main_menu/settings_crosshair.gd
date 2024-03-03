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
		file_export.visible = true

func _on_import_pressed():
	if OS.has_feature("web"):
		var window = JavaScriptBridge.get_interface("window")
		window.input.click()
	else:
		file_import.current_dir = "/"
		file_import.visible = true

func _on_export_file_dialog_file_selected(path):
	DataManager.save_all_data(path)

func _on_import_file_dialog_file_selected(path):
	DataManager.load_all_data(path)
	DataManager.save_all_data()
	emit_signal("refresh_crosshair")
	load_saved()

func _on_dot_change_value(value):
	change_value("dot_size", float(value))

func _on_dot_toggle_checkbox(value):
	change_value("dot", value)

func _on_length_change_value(value):
	change_value("length", float(value))

func _on_thickness_change_value(value):
	change_value("thickness", float(value))

func _on_outline_toggle_checkbox(value):
	change_value("outline_enable", value)

func _on_outline_change_value(value):
	change_value("outline_width", float(value))

func _on_gap_change_value(value):
	change_value("gap", float(value))

func _on_crosshair_color_color_changed(color):
	change_value("color", str(color))

func _on_outline_color_color_changed(color):
	change_value("outline_color", str(color))
	
func change_value(key, value):
	DataManager.save_data(key, value, DataManager.categories.CROSSHAIR)
	emit_signal("refresh_crosshair")

func file_parser(args):
	DataManager.load_all_data_from_param(args[0])

func load_saved():
	var categories = DataManager.categories.CROSSHAIR
	var container = $MarginContainer/VBoxContainer/CrosshairSettings
	var dot = container.get_node("Dot")
	dot.checkbox_value = DataManager.set_parameter_if_exists(categories, dot.checkbox_value, "dot")
	dot.value = DataManager.set_parameter_if_exists(categories, dot.value, "dot_size")
	var length = container.get_node("Length")
	length.value = DataManager.set_parameter_if_exists(categories, length.value, "length")
	var thickness = container.get_node("Thickness")
	thickness.value = DataManager.set_parameter_if_exists(categories, thickness.value, "thickness")
	var gap = container.get_node("Gap")
	gap.value = DataManager.set_parameter_if_exists(categories, gap.value, "gap")
	var outline = container.get_node("Outline")
	outline.checkbox_value = DataManager.set_parameter_if_exists(categories, outline.checkbox_value, "outline_enable")
	outline.value = DataManager.set_parameter_if_exists(categories, outline.value, "outline_width")
	var crosshair_color = container.get_node("Color/CrosshairColor")
	crosshair_color.color = DataManager.set_color_if_exists(categories, crosshair_color.color, "color")
	var outline_color = container.get_node("OutlineColor/OutlineColor")
	outline_color.color = DataManager.set_color_if_exists(categories, outline_color.color, "outline_color")
