extends Control

func set_score(score: int, high_score: int) -> void:
	var text = "Score: " + str(score)
	if score > high_score:
		text += "\nNew high score!"
	else:
		text += "\nCurrent high score: " + str(high_score)
	$Score.text = text

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
