extends Label
## Display the current version of the project

func _ready() -> void:
	set_text_to_current_version()

func set_text_to_current_version() -> void:
	text = get_current_version()

func get_current_version() -> String:
	return ProjectSettings.get_setting("application/config/version")
