extends Node

var gamemodes : Dictionary
var current_gamemode : Dictionary

func _ready() -> void:
	Input.set_use_accumulated_input(false)
	load_gamemodes()

func load_gamemodes() -> void:
	const PATH = "res://assets/gamemodes/"
	
	var dir = DirAccess.open(PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				var config = ConfigFile.new()
				config.load(PATH + file_name)
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
			file_name = dir.get_next()
	else:
		push_warning("An error occurred when trying to access the path.")

func get_world_textures() -> Array:
	var textures: Array = []
	var dir = DirAccess.open(get_world_textures_path())
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			if file_name.get_extension() == "import":
				var my_file_name = file_name.replace('.import', '') 
				if my_file_name.get_extension() == "png":
					textures.append(my_file_name)
			file_name = dir.get_next()
	else:
		push_warning("An error occurred when trying to access the path.")
	return textures

func get_current_world_texture() -> Texture2D:
	var current_texture = DataManager.get_data(DataManager.SETTINGS_FILE_PATH, "world", "world_texture")
	return load(get_world_textures_path() + current_texture)

func get_world_textures_path() -> String:
	return "res://assets/images/world/"
