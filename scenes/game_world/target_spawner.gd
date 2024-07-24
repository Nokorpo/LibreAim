extends Node3D

## Packed scene of the target
var _packed_target: PackedScene = preload("res://scenes/enemies/target.tscn")

@export var min_position: Vector3
@export var max_position: Vector3
@export var velocity: Vector3

func _ready() -> void:
	min_position = _get_min_position()
	max_position = _get_max_position()
	_spawn_initial_targets()

func _spawn_initial_targets():
	for target: int in range(Global.current_gamemode.initial_targets):
		_spawn_target()

func _spawn_target() -> void:
	var spawn_position: Vector3 = _get_random_target_spawn_position()
	var target: Node3D = _packed_target.instantiate()
	target.init(Global.current_gamemode.size, Global.current_gamemode.movement)
	target.min_position = min_position
	target.max_position = max_position
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.connect("hitted", Callable(self, "_on_target_hitted"))
	target.set_position(spawn_position)
	add_child(target)

func _on_target_destroyed() -> void:
	$".."._on_target_destroyed()
	_spawn_target()

func _on_target_missed() -> void:
	$".."._on_target_destroyed()

func _get_random_target_spawn_position() -> Vector3:
	return Vector3(\
		randf_range(min_position.x, max_position.x),
		randf_range(min_position.y, max_position.y),
		randf_range(min_position.z, max_position.z))

func _get_min_position() -> Vector3:
	var positions: Dictionary = Global.current_gamemode.spawn_location
	var x: float = positions.x[0]
	var y: float = positions.y[0]
	var z := 0.0
	return Vector3(x, y, z)

func _get_max_position() -> Vector3:
	var positions: Dictionary = Global.current_gamemode.spawn_location
	var x: float = positions.x[1]
	var y: float = positions.y[1]
	var z := 0.0
	return Vector3(x, y, z)
