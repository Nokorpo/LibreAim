extends CharacterBody3D

signal destroyed ## When player destroys the target
signal hitted ## When player when player hits the target

var max_health: float
var health: float = 0.0:
	set(value):
		if value < health:
			hitted.emit()
		health = value
		if health < 0.0:
			emit_signal("destroyed")
			queue_free()

var _current_velocity: Vector3 = Vector3.ZERO

@onready var _mesh_instance := $CollisionShape3D/MeshInstance3D

func _physics_process(delta: float) -> void:
	if _current_velocity != Vector3.ZERO:
		var collision_info = move_and_collide(_current_velocity * delta)
		if collision_info:
			_current_velocity = _current_velocity.bounce(collision_info.get_normal())

func init(size = {"radius": .5, "height": 1}, movement = {"x": 0, "y": 0}) -> void:
	await ready
	var collision_shape: CollisionShape3D = $CollisionShape3D
	collision_shape.shape.radius = size.radius
	collision_shape.shape.height = size.height
	_mesh_instance.mesh.radius = size.radius
	_mesh_instance.mesh.height = size.height
	_current_velocity = Vector3(randf_range(-movement.x, movement.x),\
		 randf_range(-movement.y, movement.y), 0)
	
	_set_health()
	_set_health_slider()
	_set_target_material()

func _set_health() -> void:
	max_health = Global.current_gamemode.health
	health = max_health

func _set_health_slider() -> void:
	if health > 0:
		$HealthSlider.enable()

func _set_target_material() -> void:
	var material_override = _mesh_instance.get_mesh().get_material()
	var col = DataManager.get_data(DataManager.SETTINGS_FILE_PATH, "world", "target_color")
	material_override.set_albedo(col)
	material_override.set_emission(col)
	_mesh_instance.material_override = material_override
