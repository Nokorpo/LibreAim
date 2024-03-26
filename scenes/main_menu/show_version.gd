extends Label
### Displays the current version of the game

func _ready() -> void:
	text = ProjectSettings.get_setting("application/config/version")
