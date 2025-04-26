extends VBoxContainer
## World appareance settings

@onready var world_color = $WorldColor/Color
@onready var world_texture = $WorldTexture
@onready var target_color = $TargetColor/TargetColor
@onready var preview = $Preview
@onready var target_preview = $Preview/TargetPreview

func _on_color_color_changed(color: Color) -> void:
	SaveManager.settings.set_data("world", "world_color", color)
	update_preview()

func _on_target_color_color_changed(color: Color) -> void:
	SaveManager.settings.set_data("world", "target_color", color)
	update_preview()

func _on_world_texture_item_selected(index) -> void:
	SaveManager.settings.set_data("world", "world_texture", world_texture.get_item_metadata(index))
	update_preview()

func _ready() -> void:
	var i = 0
	for path: String in Global.get_world_textures():
		world_texture.add_icon_item(CustomResourceManager.get_image(path), path.get_file(), i)
		world_texture.set_item_metadata(i, path)
		i+=1
	world_color.color = SaveManager.settings.get_data("world", "world_color")
	target_color.color = SaveManager.settings.get_data("world", "target_color")
	get_selected_texture_index()
	update_preview()

func get_selected_texture_index() -> void:
	var selected = SaveManager.settings.get_data("world", "world_texture")
	for i in range(world_texture.item_count):
		if selected == world_texture.get_item_metadata(i):
			world_texture.select(i)
	update_preview()

func update_preview() -> void:
	preview.texture = Global.get_current_world_texture()
	preview.self_modulate = SaveManager.settings.get_data("world", "world_color")
	target_preview.color = SaveManager.settings.get_data("world", "target_color")
