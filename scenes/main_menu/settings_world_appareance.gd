extends VBoxContainer
## World appareance settings

const CATEGORY = DataManager.categories.SETTINGS

@onready var world_color = $WorldColor/Color
@onready var world_texture = $WorldTexture
@onready var target_color = $TargetColor/TargetColor
@onready var preview = $Preview
@onready var target_preview = $Preview/TargetPreview

func _on_color_color_changed(color: Color) -> void:
	DataManager.save_data("world_color", str(color), CATEGORY)
	update_preview()

func _on_target_color_color_changed(color: Color) -> void:
	DataManager.save_data("target_color", str(color), CATEGORY)
	update_preview()

func _on_world_texture_item_selected(index) -> void:
	DataManager.save_data("world_texture", world_texture.get_item_text(index), CATEGORY)
	update_preview()

func _ready() -> void:
	var i = 0
	for texture in Global.get_world_textures():
		world_texture.add_icon_item(load(Global.get_world_textures_path() + texture), texture, i)
		i+=1
	world_color.color = DataManager.set_color_if_exists(CATEGORY, world_color.color, "world_color")
	target_color.color = DataManager.set_color_if_exists(CATEGORY, target_color.color, "target_color")
	get_selected_texture_index()
	update_preview()

func get_selected_texture_index() -> void:
	if DataManager.get_data(CATEGORY, "world_texture"):
		var selected = DataManager.get_data(CATEGORY, "world_texture")
		for i in range(world_texture.item_count):
			if selected == world_texture.get_item_text(i):
				world_texture.select(i)
	update_preview()

func update_preview() -> void:
	preview.texture = Global.get_current_world_texture()
	preview.self_modulate = DataManager.set_color_if_exists(CATEGORY, preview.self_modulate, "world_color")
	target_preview.color = DataManager.set_color_if_exists(CATEGORY, target_preview.color, "target_color")
