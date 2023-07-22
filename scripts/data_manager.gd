extends Node

const file_name = "open_aim_trainer.json"
const file_path = "user://" + file_name

var game_data = {}

func _ready():
	game_data = load_data()


func save_data(key, value):

	game_data[key] = value
	var json = JSON.stringify(game_data)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(json)
	file.close()

func get_data(key):
	var result = null
	if game_data != null:
		result = game_data.get(key)
	return result

func load_data():
	var json = JSON.new()
	var result = {}
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		game_data = json.parse(file.get_as_text())
		file.close()
	else:
		print("File not found.")

	if json.data != null:
		result = json.data
	return result
