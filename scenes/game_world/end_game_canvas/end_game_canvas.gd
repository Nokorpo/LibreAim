extends Control
## Canvas shown when game ends

func _ready() -> void:
	$MarginContainer/VBoxContainer/Gamemode.text = Global.current_gamemode.title
	$MarginContainer/VBoxContainer/GamemodeIcon.texture = \
		Global.get_gamemode_thumbnail(Global.current_gamemode.id)

func set_score(score: int, high_score: int, accuracy: int) -> void:
	$MarginContainer/VBoxContainer/Replay.grab_focus()
	if score > high_score:
		$MarginContainer/VBoxContainer/Container/NewHighScore.visible = true
		$MarginContainer/VBoxContainer/Container/CurrentHighScore.visible = false
	else:
		$MarginContainer/VBoxContainer/Container/NewHighScore.visible = false
		$MarginContainer/VBoxContainer/Container/CurrentHighScore.visible = true
		$MarginContainer/VBoxContainer/Container/CurrentHighScore/Label.text = "CURRENT HIGH SCORE: " + str(high_score)
		
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Score/Value.text = str(score)
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Accuracy/Value.text = str(accuracy) + "%"
	$ProgressChart.initialize()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_replay_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
