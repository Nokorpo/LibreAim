extends Control

@onready var resolution_label = $MarginContainer/VBoxContainer/ResolutionLabel
@onready var resolution_slider = $MarginContainer/VBoxContainer/ResolutionSlider
@onready var fov_label = $MarginContainer/VBoxContainer/FovLabel
@onready var fov_slider = $MarginContainer/VBoxContainer/FovSlider

func _ready():
	update_fov_label()
	update_resolution_label()
	get_viewport().size_changed.connect(self.update_resolution_label)
	var category = DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "resolution"):
		resolution_slider.value = DataManager.get_data(category, "resolution")
	if DataManager.get_data(category, "camera_fov"):
		fov_slider.value = DataManager.get_data(category, "camera_fov")

func _on_resolution_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value
	update_resolution_label()
	DataManager.save_data("resolution", value, DataManager.categories.SETTINGS)

func _on_fov_slider_value_changed(value):
	update_fov_label()
	DataManager.save_data("camera_fov", value, DataManager.categories.SETTINGS)

func update_resolution_label() -> void:
	var viewport_render_size = get_viewport().size * get_viewport().scaling_3d_scale
	resolution_label.text = "Resolution: %d × %d (%d%%)" \
		% [viewport_render_size.x, viewport_render_size.y, \
		round(get_viewport().scaling_3d_scale * 100)]

func update_fov_label() -> void:
	fov_label.text = "Camera fov: %dº" % fov_slider.value 
