extends CharacterBody3D

signal destroyed

@onready var mesh := $CollisionShape3D/MeshInstance3D

var current_velocity = null
var health = 1:
	set(value):
		health = value
		if health <= 0:
			emit_signal("destroyed")
			queue_free()

func _ready():
	var category = DataManager.categories.SETTINGS
	if DataManager.get_data(category, "TargetColor") != null:
		var material_override = mesh.get_mesh().get_material()
		material_override.set_albedo(Global.string_to_color(DataManager.get_data(category, "TargetColor")))
		material_override.set_emission(Global.string_to_color(DataManager.get_data(category, "TargetColor")))
		mesh.material_override = material_override

func init(size = 0.5, movement = false):
	self.scale = Vector3(size, size, size)
	if movement:
		current_velocity = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))

func _physics_process(delta):
	if current_velocity:
		var collision_info = move_and_collide(current_velocity * delta)
		if collision_info:
			current_velocity = current_velocity.bounce(collision_info.get_normal())
