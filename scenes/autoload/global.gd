extends Node

const TEXTURES_FOLDER := "world_textures"
const GAMEMODES_FOLDER := "gamemodes"
const DESTROY_SOUNDS_FOLDER := "destroy_sounds"

var gamemodes : Dictionary
var current_gamemode : Dictionary

func _ready() -> void:
	Input.set_use_accumulated_input(false)
	load_gamemodes()

func load_gamemodes() -> void:
	for path: String in Global.get_gamemodes():
		var config = ConfigFile.new()
		config.load(path)
		var id = config.get_value("metadata", "id")
		var this_gamemode : Dictionary = { }
		this_gamemode.id = id
		this_gamemode.title = config.get_value("metadata", "title")
		this_gamemode.description = config.get_value("metadata", "description")
		this_gamemode.time = config.get_value("settings", "time")
		this_gamemode.player_movement = config.get_value("settings", "player_movement")
		this_gamemode.movement = config.get_value("target", "movement")
		this_gamemode.health = config.get_value("target", "health")
		this_gamemode.size = config.get_value("target", "size")
		this_gamemode.initial_targets = config.get_value("target", "initial_targets")
		this_gamemode.spawn_location = config.get_value("target", "spawn_location")
		gamemodes[id] = this_gamemode

func get_world_textures() -> PackedStringArray:
	return CustomResourceManager.get_file_list(TEXTURES_FOLDER, "png")

func get_gamemodes() -> PackedStringArray:
	return CustomResourceManager.get_file_list(GAMEMODES_FOLDER, "cfg")

func get_destroy_sounds() -> PackedStringArray:
	return CustomResourceManager.get_file_list(DESTROY_SOUNDS_FOLDER, "ogg")

func get_current_world_texture() -> Texture2D:
	var wrapper := DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "world")
	var current_texture = wrapper.get_data("world_texture")
	if not CustomResourceManager.file_exists(current_texture):
		push_warning("Texture not found: %s" % current_texture)
		current_texture = wrapper.get_default_data("world_texture")
		wrapper.set_data("world_texture", current_texture)
	var image := CustomResourceManager.get_image(current_texture)
	return image

func get_current_hit_sound() -> AudioStream:
	var wrapper := DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "audio")
	var current_sound = wrapper.get_data("hit_sound")
	if not CustomResourceManager.file_exists(current_sound):
		push_warning("Sound not found: %s" % current_sound)
		current_sound = wrapper.get_default_data("hit_sound")
		wrapper.set_data("hit_sound", current_sound)
		print(current_sound)
	var sound := CustomResourceManager.get_sound(current_sound)
	return sound
