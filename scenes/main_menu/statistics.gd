extends VBoxContainer
func _ready() -> void:
	_add_scenario_labels()
	
func _add_scenario_labels() -> void:
	var scenario_list := $Scenarios
	for scenario in Global.scenarios:
		var label := RichTextLabel.new()
		label.name = scenario
		label.set_custom_minimum_size(Vector2(0, 50))
		var current_score: int = SaveManager.statistics.get_data( "totalTargetsDestroyed", Global.scenarios[scenario].id, 0)
		label.text = "\t"+Global.scenarios[scenario].title+": "+str(current_score)
		label.add_theme_font_size_override("normal_font_size", 36)
		scenario_list.add_child(label)
