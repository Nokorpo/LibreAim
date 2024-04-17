extends Control
## Controls settings

const games_sensitivities: Dictionary = {
	"Counter Strike 2": 0.022,
	"Apex Legends": 0.022,
	"Team Fortress 2": 0.022,
	"Valorant": 0.07,
}

@onready var game = $Game
@onready var sensitivity = $Sensitivity


var data_wrapper:DataManager.SectionWrapper:
	get:
		return DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "user")

func _ready() -> void:
	for sens in games_sensitivities:
		game.add_item(sens)
	sensitivity.value = data_wrapper.get_data("sensitivity")
	game.selected = data_wrapper.get_data("sensitivity_game")

func _on_sensitivity_change_value(value) -> void:
	data_wrapper.set_data("sensitivity_game", game.get_selected_id(), )
	data_wrapper.set_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(game.get_selected_id())) )
	data_wrapper.set_data("sensitivity", float(value))

func _on_game_item_selected(index: int) -> void:
	data_wrapper.set_data("sensitivity_game", index)
	data_wrapper.set_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(index)) )
