extends Control
## Controls settings

const games_sensitivities: Dictionary = {
	"Counter Strike 2": 0.022,
	"Apex Legends": 0.022,
	"Team Fortress 2": 0.022,
	"Valorant": 0.07,
}

@onready var game: OptionButton = $Game
@onready var sensitivity: Control = $Sensitivity


var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "user")

func _ready() -> void:
	for sens in games_sensitivities:
		game.add_item(sens)
	sensitivity.value = data_wrapper.get_data("sensitivity")
	#game.selected = data_wrapper.get_data("sensitivity_game")
	var selected = data_wrapper.get_data("sensitivity_game")
	for i in range(game.item_count):
		if selected == game.get_item_text(i):
			game.select(i)
	sensitivity.change_value.connect(_on_sensitivity_change_value)
	game.item_selected.connect(_on_game_item_selected)

func _on_sensitivity_change_value(value) -> void:
	data_wrapper.set_data("sensitivity_game", game.get_selected_id(), )
	data_wrapper.set_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(game.get_selected_id())) )
	data_wrapper.set_data("sensitivity", float(value))
	print(data_wrapper.get_data("sensitivity"))

func _on_game_item_selected(index: int) -> void:
	data_wrapper.set_data("sensitivity_game", game.get_item_text(index))
	data_wrapper.set_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(index)))
