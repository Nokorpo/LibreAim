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
	var cfg := ConfigFile.new()
	var wrapper := DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "crosshair")
	for key in wrapper.get_keys():
		cfg.set_value(wrapper.section, key, wrapper.get_data(key))
	cfg.save(path)

func _on_import_file_dialog_file_selected(path: String) -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(path)
	if err != OK:
		push_warning("Could not import crosshair %s"%path)
		return
	var wrapper := DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "crosshair")
	for key in cfg.get_section_keys(wrapper.section):
		wrapper.set_data(key, cfg.get_value(wrapper.section, key))
	load_saved()
	queue_refresh_crosshair()

func _on_dot_change_value(value: float) -> void:
	change_value("dot_size", float(value))

func _on_dot_toggle_checkbox(value: bool) -> void:
	change_value("dot_enable", value)

func _on_length_change_value(value: float) -> void:
	change_value("length", float(value))

func _on_thickness_change_value(value: float) -> void:
	change_value("thickness", float(value))

func _on_outline_toggle_checkbox(value: bool) -> void:
	change_value("enable_outline", value)

func _on_outline_change_value(value: float) -> void:
	change_value("outline_width", float(value))

func _on_gap_change_value(value: float) -> void:
	change_value("gap", float(value))

func _on_crosshair_color_color_changed(color: Color) -> void:
	change_value("color", color)

func _on_outline_color_color_changed(color: Color) -> void:
	change_value("outline_color", color)

func change_value(key: String, value) -> void:
	DataManager.set_data(DataManager.SETTINGS_FILE_PATH, "crosshair", key, value)
	queue_refresh_crosshair()

func queue_refresh_crosshair():
	# delay changes so we do not spam this event in load_saved()
	if not get_tree().process_frame.is_connected(emit_signal.bind("refresh_crosshair")):
		get_tree().process_frame.connect(emit_signal.bind("refresh_crosshair"), CONNECT_ONE_SHOT)

func load_saved() -> void:
	crosshair._load_save()
	const plainValueChanges := ["dot_size", "length", "thickness", "gap", "outline_width"]
	for param in plainValueChanges:
		get_node("%"+param).value = crosshair.get("_"+param)
	%dot_size.checkbox_value = crosshair._dot_enable
	%outline_width.checkbox_value = crosshair._enable_outline
	%crosshair_color.color = crosshair._color
	%outline_color.color = crosshair._outline_color
