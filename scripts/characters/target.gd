extends CharacterBody3D

signal target_kill

@onready var mesh := $CollisionShape3D/MeshInstance3D

var id_spawn_target = null
var lavelocitat = null
var health = 10 

func _ready():
	pass
	if DataManager.get_data("TargetColor") != null:
		var material_override = mesh.get_mesh().get_material()
		material_override.set_albedo(Global.string_to_color(DataManager.get_data("TargetColor")))
		material_override.set_emission(Global.string_to_color(DataManager.get_data("TargetColor")))
		mesh.material_override = material_override

func init(size = 0.5, id_spawn = null, movement = false):
	randomize()
	self.scale = Vector3(size, size, size)
	if movement:
		lavelocitat = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
	id_spawn_target = id_spawn

func _process(_delta):
	if health <= 0:
		emit_signal("target_kill")
		#DataManager.last_vectors.erase(id_spawn_target)
		queue_free()

func _physics_process(delta):
	if lavelocitat:
		var collision_info = move_and_collide(lavelocitat * delta)
		if collision_info:
			lavelocitat = lavelocitat.bounce(collision_info.get_normal())
