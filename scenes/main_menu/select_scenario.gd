extends Control
## Scenario selection in main menu

func _ready() -> void:
	_add_scenario_buttons()
	_select_scenario("random")

func _on_play_pressed() -> void:
	_start_scenario()

## Adds the scenario button list
func _add_scenario_buttons() -> void:
	var scenario_list := $Scenarios/Scenarios/ScrollContainer/Scenarios
	for scenario in Global.scenarios:
		var button := Button.new()
		button.text = Global.scenarios[scenario].title
		button.icon = Global.get_scenario_thumbnail(Global.scenarios[scenario].path)
		button.set_expand_icon(true)
		button.name = scenario
		button.set_text_alignment(HORIZONTAL_ALIGNMENT_LEFT)
		button.pressed.connect(_select_scenario.bind(button.name))
		scenario_list.add_child(button)

## Select what scenario to play
func _select_scenario(id: String) -> void:
	Global.current_scenario = Global.scenarios[id]
	
	_set_current_scenario_title(id)
	_set_current_scenario_description(id)
	var thumbnail: TextureRect = $CurrentScenario/VBoxContainer/Panel/Thumbnail
	thumbnail.texture = Global.get_scenario_thumbnail(Global.scenarios[id].path)

## Sets the scenarios title
func _set_current_scenario_title(type: String) -> void:
	var title: Label = $CurrentScenario/VBoxContainer/Title
	title.text = Global.scenarios[type].title

## Sets the scenarios description
func _set_current_scenario_description(type: String) -> void:
	var description: Label = $CurrentScenario/VBoxContainer/Description
	description.text = "%s\nTime: %s s\nHigh score: %s"\
		% [str(Global.scenarios[type].description),\
		Global.scenarios[type].time, \
		HighScoreManager.get_high_score(Global.scenarios[type].id)]

## Loads the scenario
func _start_scenario() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
