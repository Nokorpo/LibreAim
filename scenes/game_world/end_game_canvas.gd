extends Control

func set_score(score: int) -> void:
	$Score.text = "Score: " + str(score)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
