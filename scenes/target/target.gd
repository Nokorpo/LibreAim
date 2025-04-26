class_name Target
extends CharacterBody3D
## A target for the player to shoot at

signal destroyed ## When player destroys the target
signal hitted ## When player when player hits the target

var max_health: float
var health: float = 0.0:
	set(value):
		if value < health:
			hitted.emit()
		health = value
		if health < 0.0:
			destroyed.emit()
			queue_free()
var min_position: Vector3
var max_position: Vector3
var movement_behavior: TargetMovementBehavior

@onready var _mesh_instance := $CollisionShape3D/MeshInstance3D

func init(size = Vector2(1.0, 2.0), behavior: TargetMovementBehavior = TargetMovementBehavior.new(), new_health: float = 0.0) -> void:
	await ready
	var collision_shape: CollisionShape3D = $CollisionShape3D
	collision_shape.shape.radius = size.x
	collision_shape.shape.height = size.y
	_mesh_instance.mesh.radius = size.x
	_mesh_instance.mesh.height = size.y
	behavior.init(min_position, max_position)
	movement_behavior = behavior
	
	_set_health(new_health)
	_set_health_slider()
	_set_target_material()

func _physics_process(delta: float) -> void:
	move_and_collide(movement_behavior.move_process(delta, position))

func _set_health(new_health: float) -> void:
	max_health = new_health
	health = max_health

func _set_health_slider() -> void:
	if health > 0:
		$HealthSlider.enable()

func _set_target_material() -> void:
	var material_override = _mesh_instance.get_mesh().get_material()
	var col = SaveManager.settings.get_data("world", "target_color")
	material_override.set_albedo(col)
	material_override.set_emission(col)
	_mesh_instance.material_override = material_override
