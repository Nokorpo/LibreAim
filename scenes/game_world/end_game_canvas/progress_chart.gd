extends Panel

func initialize():
	var last_games: Array = []
	var cfg := DataManager.get_config(DataManager.PROGRESS_PATH + Global.current_gamemode.id)
	var i := 0
	var reverse_sections = cfg.get_sections().duplicate()
	reverse_sections.reverse()
	for section in reverse_sections:
		var reverse_keys = cfg.get_section_keys(section)
		reverse_keys.reverse()
		for key in reverse_keys:
			last_games.append(key)
			if last_games.size() > 11:
				return last_games
			var selected_pont: int = $Line2D.points.size() - i - 1
			$Line2D.points[selected_pont].y = cfg.get_value(section, key) * -10
			
			var label = Label.new()
			label.text = str(cfg.get_value(section, key))
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			$Line2D.add_child(label)
			label.position = $Line2D.points[selected_pont] + Vector2(0, -50)
			i += 1
	return last_games
