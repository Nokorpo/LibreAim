extends Node
## Canvas shown when game ends

func _ready() -> void:
	%Gamemode.text = Global.get_current_gamemode_value("title")
	%GamemodeIcon.texture = \
		Global.get_gamemode_thumbnail(Global.get_current_gamemode_value("id"))

func set_score(score: int, high_score: int, accuracy: int) -> void:
	%Replay.grab_focus()
	if score > high_score:
		%NewHighScore.visible = true
		%CurrentHighScore.visible = false
	else:
		%NewHighScore.visible = false
		%CurrentHighScore.visible = true
		%CurrentHighScore.get_node("Label").text = "CURRENT HIGH SCORE: " + str(high_score)
		
	%Score.get_node("Value").text = str(score)
	%Accuracy.get_node("Value").text = str(accuracy) + "%"
	%ProgressChart.initialize()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_replay_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://scenes/game_world/game_world.tscn")
