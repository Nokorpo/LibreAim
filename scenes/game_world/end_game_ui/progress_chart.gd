extends Panel

func initialize() -> void:
	var last_games := _get_last_games()
	
	var max_value = 0
	var min_value = 999999999999
	
	for key in last_games:
		if key > max_value:
			max_value = key
		if key < min_value:
			min_value = key
	if max_value == min_value:
		min_value -= 1
	
	var i := 0
	for key in last_games:
		var selected_pont: int = $Line2D.points.size() - i - 1
		if max_value - min_value == 0:
			max_value += 1
		$Line2D.points[selected_pont].y = (-400 * (key - min_value)) / (max_value - min_value)
		
		var label = Label.new()
		label.text = str(key)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		$Line2D.add_child(label)
		label.position = $Line2D.points[selected_pont] + Vector2(0, -50)
		i += 1

func _get_last_games() -> Array:
	var last_games: Array = []
	var cfg := ConfigFile.new()
	cfg.load(HighScoreManager.get_progress_path(Global.current_scenario.id))
	var reverse_sections = cfg.get_sections().duplicate()
	reverse_sections.reverse()
	for section in reverse_sections:
		var reverse_keys = cfg.get_section_keys(section)
		reverse_keys.reverse()
		for key in reverse_keys:
			if last_games.size() > 10:
				return last_games
			last_games.append(cfg.get_value(section, key))
	return last_games
