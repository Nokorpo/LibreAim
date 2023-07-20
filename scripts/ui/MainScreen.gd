extends Control

@onready var ResOptionButton = $MarginContainer/HBoxContainer/VBoxContainer/OptionButton
@onready var resolution_label := $MarginContainer/HBoxContainer/VBoxContainer/ResolutionLabel
@onready var gamelist := $MarginContainer/HBoxContainer/VBoxContainer2

#var Resoltuions: Dictionary = {
#	"3840x2160" : Vector2(3840,2160),
#	"2560x1440" : Vector2(2560,1440),
#	"1920x1080" : Vector2(1920,1080)
#	}


var models3d = [
	"3d_head_level_v1",
	"3d_multiple_basic_targets_movement_v1",
	"3d_multiple_basic_targets_v1",
	"3d_multiple_medium_targets_v1"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
#	AddResolutions()
	AddGames()
	get_viewport().size_changed.connect(self.update_resolution_label)
	update_resolution_label()
	
	
func AddGames():
	for model in models3d:
		var button = Button.new()
#		button.texture = preload("assets/images/" + model)
		button.text = model
		button.name = model
		gamelist.add_child(button)
#		button.connect("pressed", Callable(self, onPressed(button)))
		button.connect("pressed", Callable(self, "onPressed"))


func onPressed():
	
	print("...hola")
#	print(button.name)

#func AddResolutions():
#	var count = 0
#	for resolution in Resoltuions:
#		ResOptionButton.add_item(resolution)
#		if Resoltuions[resolution] == get_viewport().get_visible_rect().size:
#			ResOptionButton.selected = count
#		count += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_resolution_label() -> void:
	var viewport_render_size = get_viewport().size * get_viewport().scaling_3d_scale
	resolution_label.text = "3D viewport resolution: %d × %d (%d%%)" \
			% [viewport_render_size.x, viewport_render_size.y, round(get_viewport().scaling_3d_scale * 100)]


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/World.tscn")
	Global.game_type = "3d_multiple_basic_targets_movement_v1"


#func _on_option_button_item_selected(index):
#	var the_size = Resoltuions.get(ResOptionButton.get_item_text(index))
#	DisplayServer.window_set_size(the_size)


func _on_quality_slider_value_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = value
	update_resolution_label()


func _on_quit_pressed():
	get_tree().quit()
