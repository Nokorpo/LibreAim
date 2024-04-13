extends Node3D
## Manager of the game world during gameplay

## Packed scene of the target
var _packed_target: PackedScene = preload("res://scenes/enemies/target.tscn")
## Number of targets destroyed by the player
var _targets_destroyed: int = 0
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
	$CanvasLayer/EndGameCanvas.set_score(_targets_destroyed, high_score, _missed_shots)
	$CanvasLayer/GameplayUI.visible = false
	$CanvasLayer/EndGameCanvas.visible = true

func _on_target_destroyed() -> void:
	_play_destroyed_sound()
	_targets_destroyed += 1
	_gameplay_ui.update_kills(_targets_destroyed)
	_spawn_target()

func _play_destroyed_sound():
	var destroyed_sound: AudioStreamPlayer = $DestroyedSound
	destroyed_sound.pitch_scale = randf_range(0.95, 1.05)
	destroyed_sound.play()

func _on_target_missed() -> void:
	_missed_shots += 1

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
	target.set_position(spawn_position)
	add_child(target)

func _spawn_initial_targets():
	for target: int in range(Global.current_gamemode.initial_targets):
		_spawn_target()

func _update_world_appareance() -> void:
	var world_material: StandardMaterial3D = preload("res://assets/images/mat_filldummy.tres")
	world_material.albedo_texture = Global.get_current_world_texture()
	const CATEGORY = DataManager.categories.SETTINGS
	$DirectionalLight3D.light_color = DataManager.set_color_if_exists(CATEGORY, \
		$DirectionalLight3D.light_color, "world_color")
