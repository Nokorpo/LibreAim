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

func _ready():
	load_all_data()

func load_all_data_from_param(string_json):
	var json = JSON.new()
	var result = {}
	json.parse(string_json)
	if json.data != null:
		result = json.data
	game_data = result
	
func save_all_data_to_file_web():
	var json = JSON.stringify(game_data)
	JavaScriptBridge.download_buffer(json.to_utf8_buffer(),"open_aim_trainer.json")

func save_data(key, value, category: categories, file_directory = FILE_PATH):
	var category_key = CATEGORIES_ROUTES[category]
	if !game_data.has(category_key):
		game_data[category_key] = {}
	game_data[category_key][key] = value
	var json = JSON.stringify(game_data, "\t")
	var file = FileAccess.open(file_directory, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func save_high_score(key, value):
	if is_high_score(key, value):
		DataManager.save_data(key, value, DataManager.categories.HIGH_SCORE)

func is_high_score(key, value) -> bool:
	var category_key = CATEGORIES_ROUTES[DataManager.categories.HIGH_SCORE]
	if game_data.has(category_key) \
		and game_data[category_key].has(key):
		return value > game_data[category_key][key]
	else:
		return true

func save_all_data(file_directory = FILE_PATH) :
	var json = JSON.stringify(game_data, "\t")
	var file = FileAccess.open(file_directory, FileAccess.WRITE)
	file.store_line(json)
	file.close()
	
func get_data(key):
	var result = null
	if game_data != null:
		result = game_data.get(key)
	return result

func load_all_data(file_directory = FILE_PATH):
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
