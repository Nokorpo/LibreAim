extends Control

const gamemodes: Dictionary = {
	"random": {
		"title": "Random targets",
		"description": "Random static targets.",
		"spawn_location_x_0": 5,
		"spawn_location_x_1": -5,
		"spawn_location_y_0": 1,
		"spawn_location_y_1": 9,
		"time": 30,
		"movment": false,
		"size": 2,
		"number_of_initial_targets": 3
	},
	"horizontal": {
		"title": "Horizontal targets",
		"description": "All targets spawn at the same height.",
		"spawn_location_x_0": 15,
		"spawn_location_x_1": -15,
		"spawn_location_y_0": 5,
		"spawn_location_y_1": 5,
		"time": 30,
		"movment": false,
		"size": 1,
		"number_of_initial_targets": 1
	},
	"moving": {
		"title": "Moving targets",
		"description": "Targets move in random patterns.",
		"spawn_location_x_0": 15,
		"spawn_location_x_1": -15,
		"spawn_location_y_0": 1,
		"spawn_location_y_1": 9,
		"time": 30,
		"movment": true,
		"size": 2,
		"number_of_initial_targets": 6
	}
}

@onready var gamemode_list := $Control/MarginContainer/Gamemodes
@onready var title = $Control2/MarginContainer/VBoxContainer/Title
@onready var description = $Control2/MarginContainer/VBoxContainer/Description

func _ready():
	add_gamemodes()
	select_gamemode("random")

func _on_play_pressed():
	start_gamemode(Global.game_type)

func add_gamemodes():
	for gamemode in gamemodes:
		var button := Button.new()
		button.text = gamemodes[gamemode].title
		button.name = gamemode
		button.set_text_alignment(HORIZONTAL_ALIGNMENT_LEFT)
		button.pressed.connect(select_gamemode.bind(button.name))
		gamemode_list.add_child(button)

func select_gamemode(type):
	Global.game_type = gamemodes[type]
	title.text = gamemodes[type].title
	description.text = "%s\nTime: %s s" % [str(gamemodes[type].description), gamemodes[type].time]
	$Control2/MarginContainer/VBoxContainer/Panel/Miniature.texture \
		= load("res://assets/images/gamemodes/%s.svg" % type)

func start_gamemode(type):
	if !OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
