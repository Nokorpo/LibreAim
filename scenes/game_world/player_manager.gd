extends CharacterBody3D

signal shooted

const SPEED := 5
const JUMP_STRENGTH := 8

var mouse_sensitivity := 0.001

var jumps := [true, true]
var gravity := 0.0

@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var bullet_hole = preload("res://scenes/game_world/bullet_hole.tscn")

func _ready() -> void:
	var user_sensitivity := 1
	var conversion_sensitivity := 0.04
	var category := DataManager.categories.SETTINGS
	
	conversion_sensitivity = DataManager.set_parameter_if_exists(category, conversion_sensitivity, "sensitivity_game_value")
	user_sensitivity = DataManager.set_parameter_if_exists(category, user_sensitivity, "sensitivity")
	camera.fov = DataManager.set_parameter_if_exists(category, camera.fov, "camera_fov")
	mouse_sensitivity = user_sensitivity * conversion_sensitivity

func _input(event)  -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if event.is_action_pressed("shoot"):
		shoot()
	if event.is_action_pressed("jump"):
		jump()

func _physics_process(delta) -> void:
	handle_gravity(delta)
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_velocity := Vector3(input.x, 0, input.y).normalized() * SPEED
	movement_velocity = transform.basis * movement_velocity
	
	var applied_velocity := velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()

func handle_gravity(delta):
	gravity += 20 * delta
	if gravity > 0 and is_on_floor():
		for i in range(jumps.size()):
			jumps[i] = true
		gravity = 0

func jump():
	for i in range(jumps.size()):
		if jumps[i]:
			jumps[i] = false
			gravity = -JUMP_STRENGTH
			return

func shoot():
	shooted.emit()
	if raycast.is_colliding():
		var target = raycast.get_collider()
		var bullet_hole_instance = bullet_hole.instantiate()
		
		target.add_child(bullet_hole_instance)
		bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
		bullet_hole_instance.look_at(position + Vector3.FORWARD, raycast.get_collision_normal())
		
		if target.is_in_group("Enemy"):
			target.health -= 1 
