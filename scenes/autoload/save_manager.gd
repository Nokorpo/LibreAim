extends Node
## Manages the save files

var settings: SaveFile
var highscores: SaveFile

func _ready() -> void:
	settings = SaveFile.new()
	settings.initialize("user://data/settings.cfg", "res://assets/default_data/data/settings.cfg")
	highscores = SaveFile.new()
	highscores.initialize("user://data/highscores.cfg")

class SaveFile:
	var _path: String
	var _default_data_path: String
	var _file := ConfigFile.new()

	func initialize(new_path: String, new_default_data_path: String = "") -> void:
		_path = new_path
		_default_data_path = new_default_data_path
		if !FileAccess.file_exists(_path):
			if _default_data_path != "":
				_file.load(_default_data_path)
			save_data()
		else:
			load_data()

	func save_data() -> void:
		_file.save(_path)

	func load_data() -> void:
		_file.load(_path)

	func get_file() -> ConfigFile:
		return _file

	func set_data(category: String, id: String, value: Variant) -> void:
		_file.set_value(category, id, value)
		save_data()

	func get_data(category: String, id: String, default: Variant = null) -> Variant:
		if _file.has_section_key(category, id):
			return _file.get_value(category, id, default)
		elif default == null:
			return get_default_data(category, id)
		else:
			return default

	func get_default_data(category: String, id: String) -> Variant:
		var default_file := ConfigFile.new()
		default_file.load(_default_data_path)
		if default_file.has_section_key(category, id):
			return default_file.get_value(category, id)
		return null
