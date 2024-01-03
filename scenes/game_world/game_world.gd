extends Node3D

var packed_target = preload("res://scenes/enemies/target.tscn")
var count_kills := 0

@onready var timer: Timer = $Timer
@onready var gameplay_ui = $CanvasLayer/GameplayUI

func _ready() -> void:
	timer.wait_time = Global.current_gamemode.time
	
	for target: int in range(Global.current_gamemode.initial_targets):
		spawn_target()

func _process(_delta) -> void:
	if timer.is_stopped():
		gameplay_ui.update_timer_ui(timer.wait_time)
	else:
		gameplay_ui.update_timer_ui(timer.time_left)

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DataManager.save_high_score(Global.current_gamemode.id, count_kills)
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_target_destroyed() -> void:
	$DestroyedSound.pitch_scale = randf_range(0.95, 1.05)
	$DestroyedSound.play()
	count_kills += 1
	gameplay_ui.update_kills(count_kills)
	spawn_target()

func randomize_vector() -> Vector3:
	var positions: Dictionary = Global.current_gamemode.spawn_location
	var x := randf_range(positions.x[0], positions.x[1])
	var y := randf_range(positions.y[0], positions.y[1])
	var z := -16
	return Vector3(x, y, z)

func spawn_target() -> void:
	var spawn_position: Vector3 = randomize_vector()
	
	var target: Node3D = packed_target.instantiate()
	target.init(Global.current_gamemode.size, Global.current_gamemode.movement)
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.set_position(spawn_position)
	add_child(target)
