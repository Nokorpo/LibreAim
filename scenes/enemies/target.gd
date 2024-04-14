extends CharacterBody3D

signal destroyed

@onready var _mesh_instance := $CollisionShape3D/MeshInstance3D

var _current_velocity: Vector3 = Vector3.ZERO
var max_health: float
var health: float = 0.0:
	set(value):
		health = value
		if health < 0.0:
			emit_signal("destroyed")
			queue_free()

func _ready() -> void:
	_set_health()
	_set_health_slider()
	_set_target_material()

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

func _set_health() -> void:
	max_health = Global.current_gamemode.health
	health = max_health

func _set_health_slider() -> void:
	if health > 0:
		$HealthSlider.enable()

func _set_target_material() -> void:
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "target_color") != null:
		var material_override = _mesh_instance.get_mesh().get_material()
		material_override.set_albedo(Global.string_to_color(DataManager.get_data(category, "target_color")))
		material_override.set_emission(Global.string_to_color(DataManager.get_data(category, "target_color")))
		_mesh_instance.material_override = material_override
