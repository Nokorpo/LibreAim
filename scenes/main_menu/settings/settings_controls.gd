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

func _ready() -> void:
	for sens in games_sensitivities:
		game.add_item(sens)
	sensitivity.value = SaveManager.settings.get_data("user", "sensitivity")
	var selected = SaveManager.settings.get_data("user", "sensitivity_game")
	for i in range(game.item_count):
		if selected == game.get_item_text(i):
			game.select(i)
	sensitivity.change_value.connect(_on_sensitivity_change_value)
	game.item_selected.connect(_on_game_item_selected)

func _on_sensitivity_change_value(value) -> void:
	SaveManager.settings.set_data("user", "sensitivity_game", game.get_item_text(game.get_item_index(game.get_selected_id())))
	SaveManager.settings.set_data("user", "sensitivity_game_value", games_sensitivities.get(game.get_item_text(game.get_selected_id())) )
	SaveManager.settings.set_data("user", "sensitivity", float(value))

func _on_game_item_selected(index: int) -> void:
	SaveManager.settings.set_data("user", "sensitivity_game", game.get_item_text(index))
	SaveManager.settings.set_data("user", "sensitivity_game_value", games_sensitivities.get(game.get_item_text(index)))
