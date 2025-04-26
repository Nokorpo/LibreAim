extends Node3D
class_name TargetSpawner
## Spawns targets

## Packed scene of the target
var _packed_target: PackedScene = preload("res://scenes/target/target.tscn")

## Initial quantity of targets
@export var initial_targets: int = 1
## Max health of the targets
@export var health: float = 0
## Size of the target [radius, height]
@export var size: Vector2 = Vector2(2, 1)
## Min position at the target will be spawned
@export var min_position: Vector3 = Vector3(-1, -1, 0)
## Max position at the target will be spawned
@export var max_position: Vector3 = Vector3(1, 1, 0)

## Movement behavior script
@export var behavior: TargetMovementBehavior

func _ready() -> void:
	_spawn_initial_targets()

func _spawn_initial_targets() -> void:
	for target: int in range(initial_targets):
		_spawn_target()

func _spawn_target() -> void:
	var spawn_position: Vector3 = _get_valid_target_spawn_position()
	var target: Target = _packed_target.instantiate()
	target.init(size, behavior.duplicate(), health)
	target.min_position = min_position
	target.max_position = max_position
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.connect("hitted", Callable(self, "_on_target_hitted"))
	target.set_position(spawn_position)
	add_child(target)

func _on_target_destroyed() -> void:
	$"..".target_destroyed.emit()
	_spawn_target()

func _on_target_hitted() -> void:
	$"..".target_hitted.emit()

func _on_target_missed() -> void:
	$"..".target_destroyed.emit()

func _get_valid_target_spawn_position() -> Vector3:
	var is_position_valid := false
	var selected_position: Vector3 
	var valid_distance := 2.0
	while !is_position_valid:
		selected_position = _get_random_target_spawn_position()
		is_position_valid = _is_position_valid(selected_position, valid_distance)
		valid_distance *= 0.9
	return selected_position

## Returns false if targets are overlapping
func _is_position_valid(this_position: Vector3, valid_distance: float) -> bool:
	for child: Node3D in get_children():
		var distance: Vector3 = child.position - this_position
		if distance.length() < valid_distance:
			return false
	return true

func _get_random_target_spawn_position() -> Vector3:
	return Vector3(\
		randf_range(min_position.x, max_position.x),
		randf_range(min_position.y, max_position.y),
		randf_range(min_position.z, max_position.z))
