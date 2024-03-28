extends Node

const FILE_NAME := "settings.json"
const FILE_PATH := "user://" + FILE_NAME
## JSON file is divided in categories in order to keep things organized.
const CATEGORIES_ROUTES := {
	categories.SETTINGS: "settings",
	categories.CROSSHAIR: "crosshair",
	categories.HIGH_SCORE: "high_score"
}

enum categories { SETTINGS, CROSSHAIR, HIGH_SCORE }

var game_data := {}

func _ready() -> void:
	load_all_data()

func save_data(key, value, category: categories, file_directory = FILE_PATH) -> void:
	var category_key = CATEGORIES_ROUTES[category]
	if !game_data.has(category_key):
		game_data[category_key] = {}
	game_data[category_key][key] = value
	var json = JSON.stringify(game_data, "\t")
	var file = FileAccess.open(file_directory, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func save_high_score(key: String, value) -> void:
	if is_high_score(key, value):
		DataManager.save_data(key, value, DataManager.categories.HIGH_SCORE)

func is_high_score(key: String, value) -> bool:
	var category_key = CATEGORIES_ROUTES[DataManager.categories.HIGH_SCORE]
	if game_data.has(category_key) \
		and game_data[category_key].has(key):
		return value > game_data[category_key][key]
	else:
		return true

func get_high_score(key: String) -> int:
	var category_key = CATEGORIES_ROUTES[DataManager.categories.HIGH_SCORE]
	if game_data.has(category_key) \
		and game_data[category_key].has(key):
			return game_data[category_key][key]
	return 0

func save_all_data(file_directory: String = FILE_PATH) -> void:
	var json = JSON.stringify(game_data, "\t")
	var file = FileAccess.open(file_directory, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func get_data(category: categories, key: String):
	var result = null
	if game_data != null \
		and game_data.has(CATEGORIES_ROUTES[category]) \
		and game_data.get(CATEGORIES_ROUTES[category]).has(key):
		result = game_data.get(CATEGORIES_ROUTES[category]).get(key)
	return result

func load_all_data(file_directory: String = FILE_PATH) -> void:
	var json = JSON.new()
	var result = {}
	var file = FileAccess.open(file_directory, FileAccess.READ)
	if file:
		json.parse(file.get_as_text())
		file.close()
	else:
		print("File not found.")

	if json.data != null:
		result = json.data
	game_data = result

func set_parameter_if_exists(category: categories, parameter, key: String):
	var new_value = DataManager.get_data(category, key)
	if new_value != null:
		return new_value
	return parameter

func set_color_if_exists(category: categories, parameter: Color, key: String) -> Color:
	var new_color = set_parameter_if_exists(category, parameter, key)
	if new_color != null and new_color is String:
		new_color = Global.string_to_color(new_color)
	return new_color
