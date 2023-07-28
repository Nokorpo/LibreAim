extends Control

@onready var game = $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Game
@onready var resolution_label := $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/ResolutionLabel
@onready var gamelist := $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer2
@onready var slider_quality := $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/QualitySlider
@onready var sensitivity := $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Sensitivity
@onready var exit_button = $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/Quit

#4k
var games_sensitivities: Dictionary = {
	"Valorant": 0.0707589285714285,
	"CounterStrike": 0.0222372497081799,
	"Fortnite": 0.00561534231977053
	}

var models3d: Dictionary = {
	"3d_head_level_v1": {
		"spawn_location_x_0": 24,
		"spawn_location_x_1": -24,
		"spawn_location_y_0": 4,
		"spawn_location_y_1": 4,
		"movment": false,
		"size": 0.5,
		"number_of_initial_targets": 1
	},
	"3d_multiple_basic_targets_movement_v1": {
		"spawn_location_x_0": 12,
		"spawn_location_x_1": -12,
		"spawn_location_y_0": 4,
		"spawn_location_y_1": 20,
		"movment": true,
		"size": 0.5,
		"number_of_initial_targets": 6
	},
	"3d_multiple_basic_targets_v1": {
		"spawn_location_x_0": 12,
		"spawn_location_x_1": -12,
		"spawn_location_y_0": 4,
		"spawn_location_y_1": 20,
		"movment": false,
		"size": 0.5,
		"number_of_initial_targets": 6
	},
	"3d_multiple_medium_targets_v1": {
		"spawn_location_x_0": 11,
		"spawn_location_x_1": -11,
		"spawn_location_y_0": 4,
		"spawn_location_y_1": 15,
		"movment": false,
		"size": 3,
		"number_of_initial_targets": 3
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("web"):
		slider_quality.visible = false
		resolution_label.visible = false
		exit_button.visible = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	AddGamesSensitivities()
	if DataManager.get_data("resolution"):
		slider_quality.value = DataManager.get_data("resolution")
	if DataManager.get_data("sensitivity"):
		sensitivity.text = str(DataManager.get_data("sensitivity"))
	if DataManager.get_data("sensitivity_game"):
		game.selected = DataManager.get_data("sensitivity_game")
	AddGames()
	get_viewport().size_changed.connect(self.update_resolution_label)
	update_resolution_label()

#func _process(_delta):
#	if Input.is_action_pressed("f_pressed"):
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func AddGamesSensitivities():
	for sens in games_sensitivities:
		game.add_item(sens)


func AddGames():
	for model in models3d:
		var hboxc = HBoxContainer.new()
		
		var button = Button.new()
		button.text = model
		button.name = model
		button.pressed.connect(startTraining.bind(button.name))
		


		var texture_rect = TextureRect.new()
		texture_rect.texture = load("res://assets/images/games/" + model +".png")
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE 
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		texture_rect.set_size(Vector2(300, 300))

		var wrapper = Control.new()
		wrapper.custom_minimum_size = Vector2(300, 300) 
		wrapper.add_child(texture_rect)


		hboxc.add_child(wrapper)
		hboxc.add_child(button)
		gamelist.add_child(hboxc)

func startTraining(type):
	if !OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.game_type = models3d[type]
	get_tree().change_scene_to_file("res://scenes/levels/World.tscn")


func update_resolution_label() -> void:
	var viewport_render_size = get_viewport().size * get_viewport().scaling_3d_scale
	resolution_label.text = "3D viewport resolution: %d × %d (%d%%)" \
			% [viewport_render_size.x, viewport_render_size.y, round(get_viewport().scaling_3d_scale * 100)]


func _on_play_pressed():
	var keys = []
	for key in models3d.keys():
		keys.push_back(key)
	
	var random_index = randi() % keys.size()
	var value = keys[random_index]
	startTraining(value)


func _on_quality_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value
	update_resolution_label()
	DataManager.save_data("resolution", value)


func _on_quit_pressed():
	get_tree().quit()


func _on_sensitivity_text_changed(new_text):
	DataManager.save_data("sensitivity_game", game.get_selected_id())
	DataManager.save_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(game.get_selected_id())))
	DataManager.save_data("sensitivity", float(new_text))


func _on_game_item_selected(index):
	DataManager.save_data("sensitivity_game", index)
	DataManager.save_data("sensitivity_game_value", games_sensitivities.get(game.get_item_text(index)))


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/Options.tscn")
