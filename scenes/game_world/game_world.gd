extends Node3D
## Manager of the game world during gameplay

## Packed scene of the target
var _packed_target: PackedScene = preload("res://scenes/enemies/target.tscn")
## Number of targets destroyed by the player
var _targets_destroyed: int = 0
## Number of shots missed by the player
var _hitted_shots: int = 0
## Number of shots missed by the player
var _missed_shots: int = 0

@onready var _timer: Timer = $Timer
@onready var _gameplay_ui: Control = $CanvasLayer/GameplayUI

func _ready() -> void:
	if Global.current_gamemode:
		_timer.wait_time = Global.current_gamemode.time
		_spawn_initial_targets()
	_update_world_appareance()
	$Player.connect("missed", Callable(self, "_on_target_missed"))

func _process(_delta: float) -> void:
	if _timer.is_stopped():
		_gameplay_ui.update_timer_ui(_timer.wait_time)
	else:
		_gameplay_ui.update_timer_ui(_timer.time_left)

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_timer.stop()
	var high_score := DataManager.get_high_score(Global.current_gamemode.id)
	DataManager.save_high_score(Global.current_gamemode.id, _targets_destroyed)
	$Player.queue_free()
	$CanvasLayer/PauseManager.queue_free()
	$CanvasLayer/EndGameCanvas.set_score(_get_score(), high_score, _missed_shots)
	$CanvasLayer/GameplayUI.visible = false
	$CanvasLayer/EndGameCanvas.visible = true

func _on_target_destroyed() -> void:
	_gameplay_ui.target_destroyed(_get_score(), _get_accuracy())
	_play_destroyed_sound()
	_targets_destroyed += 1
	_spawn_target()

func _on_target_missed() -> void:
	_missed_shots += 1
	_gameplay_ui.update_score(_get_score(), _get_accuracy())

func _on_target_hitted() -> void:
	_hitted_shots += 1
	_gameplay_ui.update_score(_get_score(), _get_accuracy())

func _play_destroyed_sound():
	var destroyed_sound: AudioStreamPlayer = $DestroyedSound
	destroyed_sound.pitch_scale = randf_range(0.95, 1.05)
	destroyed_sound.play()

func _get_score() -> int:
	if Global.current_gamemode:
		var score = _hitted_shots * Global.current_gamemode.score_per_hit
		if Global.current_gamemode.accuracy_multiplier:
			score = score * (_get_accuracy() / 100)
		return score
	else:
		return _hitted_shots

func _get_accuracy() -> float:
	if _missed_shots == 0:
		return 100
	if _hitted_shots == 0:
		return 0
	return (float(_hitted_shots) / (float(_hitted_shots) + float(_missed_shots))) * 100

func _get_random_target_spawn_position() -> Vector3:
	var positions: Dictionary = Global.current_gamemode.spawn_location
	var x := randf_range(positions.x[0], positions.x[1])
	var y := randf_range(positions.y[0], positions.y[1])
	var z := -16
	return Vector3(x, y, z)

func _spawn_target() -> void:
	var spawn_position: Vector3 = _get_random_target_spawn_position()
	var target: Node3D = _packed_target.instantiate()
	target.init(Global.current_gamemode.size, Global.current_gamemode.movement)
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.connect("hitted", Callable(self, "_on_target_hitted"))
	target.set_position(spawn_position)
	add_child(target)

func _spawn_initial_targets():
	for target: int in range(Global.current_gamemode.initial_targets):
		_spawn_target()

func _update_world_appareance() -> void:
	var world_material: StandardMaterial3D = preload("res://assets/material_default.tres")
	world_material.albedo_texture = Global.get_current_world_texture()
	var wrapper = DataManager.get_wrapper(DataManager.SETTINGS_FILE_PATH, "world")
	$DirectionalLight3D.light_color = wrapper.get_data("world_color")
