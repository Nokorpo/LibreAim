extends Control
## Canvas shown when game ends

func set_score(score: int, high_score: int, missed_shots: int) -> void:
	$Button.grab_focus()
	var text = "Score: " + str(score)
	if score > high_score:
		text += "\nNew high score!"
	else:
		text += "\nCurrent high score: " + str(high_score)
	text += "\nShots missed: " + str(missed_shots)
	$Score.text = text

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
