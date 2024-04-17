extends VBoxContainer
## World appareance settings

@onready var world_color = $WorldColor/Color
@onready var world_texture = $WorldTexture
@onready var target_color = $TargetColor/TargetColor
@onready var preview = $Preview
@onready var target_preview = $Preview/TargetPreview

var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "world")

func _on_color_color_changed(color: Color) -> void:
	data_wrapper.set_data("world_color", color)
	update_preview()

func _on_target_color_color_changed(color: Color) -> void:
	data_wrapper.set_data("target_color", color)
	update_preview()

func _on_world_texture_item_selected(index) -> void:
	data_wrapper.set_data("world_texture", world_texture.get_item_text(index))
	update_preview()

func _ready() -> void:
	var i = 0
	for texture in Global.get_world_textures():
		world_texture.add_icon_item(load(Global.get_world_textures_path() + texture), texture, i)
		i+=1
	world_color.color = data_wrapper.get_data("world_color")
	target_color.color = data_wrapper.get_data("target_color")
	get_selected_texture_index()
	update_preview()

func get_selected_texture_index() -> void:
	var selected = data_wrapper.get_data("world_texture")
	for i in range(world_texture.item_count):
		if selected == world_texture.get_item_text(i):
			world_texture.select(i)
	update_preview()

func update_preview() -> void:
	preview.texture = Global.get_current_world_texture()
	preview.self_modulate = data_wrapper.get_data("world_color")
	target_preview.color = data_wrapper.get_data("target_color")
