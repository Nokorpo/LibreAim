extends Control

@onready var gamemode_list := $Control/MarginContainer/Gamemodes
@onready var title = $Control2/MarginContainer/VBoxContainer/Title
@onready var description = $Control2/MarginContainer/VBoxContainer/Description

func _ready():
	add_gamemodes()
	select_gamemode("random")

func _on_play_pressed():
	start_gamemode(Global.current_gamemode)

func add_gamemodes():
	for gamemode in Global.gamemodes:
		var button := Button.new()
		button.text = Global.gamemodes[gamemode].title
		button.name = gamemode
		button.set_text_alignment(HORIZONTAL_ALIGNMENT_LEFT)
		button.pressed.connect(select_gamemode.bind(button.name))
		gamemode_list.add_child(button)

func select_gamemode(type):
	Global.current_gamemode = Global.gamemodes[type]
	title.text = Global.gamemodes[type].title
	description.text = "%s\nTime: %s s" % [str(Global.gamemodes[type].description), Global.gamemodes[type].time]
	$Control2/MarginContainer/VBoxContainer/Panel/Miniature.texture \
		= load("res://assets/images/gamemodes/%s.svg" % type)

func start_gamemode(type):
	if !OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
