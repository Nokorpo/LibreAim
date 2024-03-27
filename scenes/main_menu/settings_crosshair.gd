extends Control
## Crosshair settings

signal refresh_crosshair

@onready var crosshair := $CrosshairSettings/Preview/Crosshair
@onready var file_export := $ExportFileDialog
@onready var file_import := $ImportFileDialog

func _ready() -> void:
	file_export.visible = false
	file_import.visible = false
	load_saved()

func _on_export_pressed() -> void:
	file_export.current_dir = "/"
	file_export.visible = true

func _on_import_pressed() -> void:
	file_import.current_dir = "/"
	file_import.visible = true

func _on_export_file_dialog_file_selected(path: String) -> void:
	DataManager.save_all_data(path)

func _on_import_file_dialog_file_selected(path: String) -> void:
	DataManager.load_all_data(path)
	DataManager.save_all_data()
	emit_signal("refresh_crosshair")
	load_saved()

func _on_dot_change_value(value: float) -> void:
	change_value("dot_size", float(value))

func _on_dot_toggle_checkbox(value: bool) -> void:
	change_value("dot", value)

func _on_length_change_value(value: float) -> void:
	change_value("length", float(value))

func _on_thickness_change_value(value: float) -> void:
	change_value("thickness", float(value))

func _on_outline_toggle_checkbox(value: bool) -> void:
	change_value("outline_enable", value)

func _on_outline_change_value(value: float) -> void:
	change_value("outline_width", float(value))

func _on_gap_change_value(value: float) -> void:
	change_value("gap", float(value))

func _on_crosshair_color_color_changed(color: Color) -> void:
	change_value("color", str(color))

func _on_outline_color_color_changed(color: Color) -> void:
	change_value("outline_color", str(color))
	
func change_value(key: String, value) -> void:
	DataManager.save_data(key, value, DataManager.categories.CROSSHAIR)
	emit_signal("refresh_crosshair")

func load_saved() -> void:
	const CATEGORY := DataManager.categories.CROSSHAIR
	var container := $CrosshairSettings
	var dot := container.get_node("Dot")
	dot.checkbox_value = DataManager.set_parameter_if_exists(CATEGORY, dot.checkbox_value, "dot")
	dot.value = DataManager.set_parameter_if_exists(CATEGORY, dot.value, "dot_size")
	var length := container.get_node("Length")
	length.value = DataManager.set_parameter_if_exists(CATEGORY, length.value, "length")
	var thickness := container.get_node("Thickness")
	thickness.value = DataManager.set_parameter_if_exists(CATEGORY, thickness.value, "thickness")
	var gap := container.get_node("Gap")
	gap.value = DataManager.set_parameter_if_exists(CATEGORY, gap.value, "gap")
	var outline := container.get_node("Outline")
	outline.checkbox_value = DataManager.set_parameter_if_exists(CATEGORY, outline.checkbox_value, "outline_enable")
	outline.value = DataManager.set_parameter_if_exists(CATEGORY, outline.value, "outline_width")
	var crosshair_color := container.get_node("Color/CrosshairColor")
	crosshair_color.color = DataManager.set_color_if_exists(CATEGORY, crosshair_color.color, "color")
	var outline_color := container.get_node("OutlineColor/OutlineColor")
	outline_color.color = DataManager.set_color_if_exists(CATEGORY, outline_color.color, "outline_color")
