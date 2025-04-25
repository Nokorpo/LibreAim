extends CharacterBody3D
class_name Target
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

func init(size = {"radius": .5, "height": 1}, movement = {"x": 0, "y": 0}, behavior: TargetMovementBehavior = TargetMovementBehavior.new()) -> void:
	await ready
	var collision_shape: CollisionShape3D = $CollisionShape3D
	collision_shape.shape.radius = size.radius
	collision_shape.shape.height = size.height
	_mesh_instance.mesh.radius = size.radius
	_mesh_instance.mesh.height = size.height
	behavior.init(min_position, max_position, movement)
	movement_behavior = behavior
	
	_set_health()
	_set_health_slider()
	_set_target_material()

func _physics_process(delta: float) -> void:
	move_and_collide(movement_behavior.move_process(delta, position))

func _set_health() -> void:
	max_health = Global.current_gamemode.health
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
