extends Node3D

var packed_target = preload("res://scenes/enemies/target.tscn")
var count_kills := 0

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = Global.current_gamemode.time
	
	for target: int in range(Global.current_gamemode.number_of_initial_targets):
		spawn_target()

func _process(_delta) -> void:
	if timer.is_stopped():
		$CanvasLayer/GameplayUI.update_timer_ui(timer.wait_time)
	else:
		$CanvasLayer/GameplayUI.update_timer_ui(timer.time_left)

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DataManager.save_high_score(Global.current_gamemode.id, count_kills)
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_player_shoot() -> void:
	if timer.is_stopped():
		timer.start()
		$CanvasLayer/GameplayUI/PressAny.queue_free()

func _on_target_destroyed() -> void:
	count_kills += 1
	$CanvasLayer/GameplayUI.update_kills(count_kills)
	spawn_target()

func randomize_vector() -> Vector3:
	randomize()
	var location_x = randf_range(Global.current_gamemode.spawn_location_x_0, Global.current_gamemode.spawn_location_x_1)
	var location_y = randf_range(Global.current_gamemode.spawn_location_y_0, Global.current_gamemode.spawn_location_y_1)
	var location_z = -16
	return Vector3(location_x, location_y, location_z)

func spawn_target() -> void:
	var spawn_position: Vector3 = randomize_vector()
	
	var target: Node3D = packed_target.instantiate()
	target.init(Global.current_gamemode.size, Global.current_gamemode.movment)
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.set_position(spawn_position)
	add_child(target)
