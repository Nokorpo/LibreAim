extends Node
## Manages some stuff that should be loaded when game starts
# Maby this should have another name, or should be organized in another way

const TEXTURES_FOLDER := "world_textures"
const SCENARIOS_FOLDER := "scenarios"
const DESTROY_SOUNDS_FOLDER := "destroy_sounds"

var scenarios : Dictionary
var current_scenario : Dictionary

func _ready() -> void:
	Input.set_use_accumulated_input(false)
	CustomResourceManager.copy_sample_custom_resources()
	_load_scenarios()

## Returns the value of a key of the current scenario
func get_current_scenario_value(value: String) -> Variant:
	if Global.current_scenario.is_empty():
		Global.current_scenario = Global.scenarios["random"]
	return current_scenario[value]

func get_world_textures() -> PackedStringArray:
	return CustomResourceManager.get_file_list(TEXTURES_FOLDER, "png")

## Returns a list of paths to all scenarios
func get_scenarios() -> PackedStringArray:
	return CustomResourceManager.get_folder_list(SCENARIOS_FOLDER)

## Returns the thumbnail
func get_scenario_thumbnail(path: String) -> Texture2D:
	var texture_path = "%sicon.svg" % path
	if ResourceLoader.exists(texture_path):
		return load(texture_path)
	elif FileAccess.file_exists(path + "icon.svg"):
		var image := Image.load_from_file(texture_path)
		if image != null:
			return ImageTexture.create_from_image(image)
	
	return load("res://assets/images/missing.svg")

func get_destroy_sounds() -> PackedStringArray:
	return CustomResourceManager.get_file_list(DESTROY_SOUNDS_FOLDER, "ogg")

func get_current_world_texture() -> Texture2D:
	var current_texture = SaveManager.settings.get_data("world", "world_texture")
	if not FileAccess.file_exists(current_texture):
		push_warning("Texture not found: %s" % current_texture)
		current_texture = SaveManager.settings.get_default_data("world", "world_texture")
		SaveManager.settings.set_data("world", "world_texture", current_texture)
	var image := CustomResourceManager.get_image(current_texture)
	return image

func get_current_hit_sound() -> AudioStream:
	var current_sound = SaveManager.settings.get_data("audio", "hit_sound")
	if not FileAccess.file_exists(current_sound):
		push_warning("Sound not found: %s" % current_sound)
		current_sound = SaveManager.settings.get_default_data("audio", "hit_sound")
		SaveManager.settings.set_data("audio", "hit_sound", current_sound)
	var sound := CustomResourceManager.get_sound(current_sound)
	return sound

func _load_scenarios() -> void:
	for path: String in Global.get_scenarios():
		if !FileAccess.file_exists(path + "scenario.tscn"):
			break
		var config = ConfigFile.new()
		config.load(path + "info.cfg")
		if !config.has_section_key("metadata", "id"):
			break
		var id = config.get_value("metadata", "id")
		var this_scenario: Dictionary = { }
		
		this_scenario.id = id
		for section: String in config.get_sections():
			for key: String in config.get_section_keys(section):
				this_scenario[key] = config.get_value(section, key)
		this_scenario["path"] = path
		scenarios[id] = this_scenario
