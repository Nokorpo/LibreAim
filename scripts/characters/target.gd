extends CharacterBody3D

@onready var mesh := $CollisionShape3D/MeshInstance3D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal target_kill

var id_spawn_target = null

var lavelocitat = null

var health = 10 


# Called when the node enters the scene tree for the first time.
func _ready():
	if DataManager.get_data("TargetColor") != null:
		var material_override = StandardMaterial3D.new()
		material_override.set_albedo(Global.string_to_color(DataManager.get_data("TargetColor")) )
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


