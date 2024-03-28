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
		print("An error occurred when trying to access the path.")

func get_world_textures() -> Array:
	var textures: Array = []
	var dir = DirAccess.open(get_world_textures_path())
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			elif file_name.get_extension() == "png":
				#print(PATH + file_name)
				textures.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return textures

func get_current_world_texture() -> Texture2D:
	const CATEGORY = DataManager.categories.SETTINGS
	var current_texture = DataManager.get_data(CATEGORY, "world_texture")
	if !current_texture:
		current_texture = "checkerboard.png"
	return load(get_world_textures_path() + current_texture)

func get_world_textures_path() -> String:
	return "res://assets/images/world/"

func string_to_vector3d(string_vector: String) -> Vector3:
	var components_str = string_vector.substr(1, string_vector.length() - 2)
	var components = components_str.split(",")

	# Convert each component from string to float
	var x = components[0].to_float()
	var y = components[1].to_float()
	var z = components[2].to_float()

	# Create the Vector3D object
	return Vector3(x, y, z)

func string_to_color(string_vector: String) -> Color:
	var components_str = string_vector.substr(1, string_vector.length() - 2)
	var components = components_str.split(",")

	# Convert each component from string to float
	var r = components[0].to_float()
	var g = components[1].to_float()
	var b = components[2].to_float()
	var a = components[3].to_float()

	# Create the Vector3D object
	return Color(r, g, b, a)
