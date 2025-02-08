extends Control
## Gamemode selection in main menu

func _ready() -> void:
	_add_gamemode_buttons()
	_select_gamemode("random")

func _on_play_pressed() -> void:
	_start_gamemode()

## Adds the gamemodes button list
func _add_gamemode_buttons() -> void:
	var gamemode_list := $ListGamemodes/Gamemodes/ScrollContainer/Gamemodes
	for gamemode in Global.gamemodes:
		var button := Button.new()
		button.text = Global.gamemodes[gamemode].title
		button.icon = Global.get_gamemode_thumbnail(gamemode)
		button.set_expand_icon(true)
		button.name = gamemode
		button.set_text_alignment(HORIZONTAL_ALIGNMENT_LEFT)
		button.pressed.connect(_select_gamemode.bind(button.name))
		gamemode_list.add_child(button)

## Select what gamemode to play
func _select_gamemode(type: String) -> void:
	Global.current_gamemode = Global.gamemodes[type]
	
	_set_current_gamemode_title(type)
	_set_current_gamemode_description(type)
	var thumbnail: TextureRect = $CurrentGamemode/VBoxContainer/Panel/Thumbnail
	thumbnail.texture \
		= Global.get_gamemode_thumbnail(type)

## Sets the gamemode title
func _set_current_gamemode_title(type: String) -> void:
	var title: Label = $CurrentGamemode/VBoxContainer/Title
	title.text = Global.gamemodes[type].title

## Sets the gamemode description
func _set_current_gamemode_description(type: String) -> void:
	var description: Label = $CurrentGamemode/VBoxContainer/Description
	description.text = "%s\nTime: %s s\nHigh score: %s"\
		% [str(Global.gamemodes[type].description),\
		Global.gamemodes[type].time, \
		HighScoreManager.get_high_score(Global.gamemodes[type].id)]

## Loads the gamemode
func _start_gamemode() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
