extends Control
## Video settings

@onready var resolution_slider = $ResolutionSlider
@onready var fov_label = $FovLabel
@onready var fov_slider = $FovSlider
@onready var window_mode_options = $WindowModeOptions

func _ready() -> void:
	DisplayManager.window_mode_updated.connect(_on_display_manager_window_mode_updated)
	_update_fov_label()
	_update_resolution_label()
	get_viewport().size_changed.connect(self._update_resolution_label)
	
	resolution_slider.value = SaveManager.settings.get_data("video", "resolution")
	fov_slider.value = SaveManager.settings.get_data("video", "fov")
	var selected = SaveManager.settings.get_data("video", "window_mode")
	for i in range(window_mode_options.item_count):
		if selected == window_mode_options.get_item_text(i):
			window_mode_options.select(i) 

func _on_resolution_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value
	_update_resolution_label()
	SaveManager.settings.set_data("video", "resolution", value)

func _on_fov_slider_value_changed(value: float) -> void:
	_update_fov_label()
	SaveManager.settings.set_data("video", "fov", value)
	
func _on_window_mode_options_item_selected(index: int) -> void:
	var option = window_mode_options.get_item_text(index)
	DisplayManager.set_window_mode_from_string(option)
	SaveManager.settings.set_data("video", "window_mode", option)

func _on_display_manager_window_mode_updated(window_mode):
	var selected = DisplayManager.get_string_from_window_mode(window_mode)
	for i in range(window_mode_options.item_count):
		if selected == window_mode_options.get_item_text(i):
			window_mode_options.select(i)

func _update_resolution_label() -> void:
	var viewport_render_size = get_viewport().size * get_viewport().scaling_3d_scale
	var resolution_label = $ResolutionLabel
	resolution_label.text = "Resolution: %d × %d (%d%%)" \
		% [viewport_render_size.x, viewport_render_size.y, \
		round(get_viewport().scaling_3d_scale * 100)]

func _update_fov_label() -> void:
	fov_label.text = "Camera fov: %dº" % fov_slider.value 
