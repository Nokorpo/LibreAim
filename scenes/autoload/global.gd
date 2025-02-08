extends Node

const TEXTURES_FOLDER := "world_textures"
const GAMEMODES_FOLDER := "gamemodes"
const DESTROY_SOUNDS_FOLDER := "destroy_sounds"

var gamemodes : Dictionary
var current_gamemode : Dictionary

func _ready() -> void:
	Input.set_use_accumulated_input(false)
	_load_gamemodes()

func get_current_gamemode_value(value: String) -> Variant:
	if Global.current_gamemode.is_empty():
		Global.current_gamemode = Global.gamemodes["random"]
	return current_gamemode[value]

func get_world_textures() -> PackedStringArray:
	return CustomResourceManager.get_file_list(TEXTURES_FOLDER, "png")

func get_gamemodes() -> PackedStringArray:
	return CustomResourceManager.get_file_list(GAMEMODES_FOLDER, "cfg")

## Returns the gamemode thumbnail
func get_gamemode_thumbnail(id: String) -> CompressedTexture2D:
	var texture_path = "res://assets/images/gamemodes/%s.svg" % id
	if ResourceLoader.exists(texture_path):
		return load(texture_path)
	return load("res://assets/images/gamemodes/missing.svg")

func get_destroy_sounds() -> PackedStringArray:
	return CustomResourceManager.get_file_list(DESTROY_SOUNDS_FOLDER, "ogg")

func get_current_world_texture() -> Texture2D:
	var current_texture = SaveManager.settings.get_data("world", "world_texture")
	if not CustomResourceManager.file_exists(current_texture):
		push_warning("Texture not found: %s" % current_texture)
		current_texture = SaveManager.settings.get_default_data("world", "world_texture")
		SaveManager.settings.set_data("world", "world_texture", current_texture)
	var image := CustomResourceManager.get_image(current_texture)
	return image

func get_current_hit_sound() -> AudioStream:
	var current_sound = SaveManager.settings.get_data("audio", "hit_sound")
	if not CustomResourceManager.file_exists(current_sound):
		push_warning("Sound not found: %s" % current_sound)
		current_sound = SaveManager.settings.get_default_data("audio", "hit_sound")
		SaveManager.settings.set_data("audio", "hit_sound", current_sound)
	var sound := CustomResourceManager.get_sound(current_sound)
	return sound

func _load_gamemodes() -> void:
	for path: String in Global.get_gamemodes():
		var config = ConfigFile.new()
		config.load(path)
		var id = config.get_value("metadata", "id")
		var this_gamemode : Dictionary = { }
		
		this_gamemode.id = id
		for section: String in config.get_sections():
			for key: String in config.get_section_keys(section):
				this_gamemode[key] = config.get_value(section, key)
		gamemodes[id] = this_gamemode
