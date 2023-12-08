extends CharacterBody3D

signal shooted

const SPEED = 5
const JUMP_STRENGTH = 8
const DAMAGE = 10

var mouse_sensitivity := 0.001

var jump_single := true
var jump_double := true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var bullet_hole = preload("res://scenes/game_world/bullet_hole.tscn")

func _ready() -> void:
	var user_sensitivity := 1
	var conversion_sensitivity := 0.04
	var category := DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "sensitivity_game_value"):
		conversion_sensitivity = DataManager.get_data(category, "sensitivity_game_value")
	if DataManager.get_data(category, "sensitivity"):
		user_sensitivity = DataManager.get_data(category, "sensitivity")
	if DataManager.get_data(category, "camera_fov"):
		camera.fov = DataManager.get_data(category, "camera_fov")
	if OS.has_feature("web"):
		mouse_sensitivity = user_sensitivity * conversion_sensitivity * 0.67857142857142857143
	else:
		mouse_sensitivity = user_sensitivity * conversion_sensitivity

func _input(event)  -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("jump"):
		if jump_double:
			gravity = -JUMP_STRENGTH
			jump_double = false
		if jump_single:
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
		jump_single = true
		gravity = 0

func jump():
	gravity = -JUMP_STRENGTH
	jump_single = false;
	jump_double = true;

func shoot():
	shooted.emit()
	if raycast.is_colliding():
		var target = raycast.get_collider()
		var bullet_hole_instance = bullet_hole.instantiate()
		
		target.add_child(bullet_hole_instance)
		bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
		bullet_hole_instance.look_at(position + Vector3.FORWARD, raycast.get_collision_normal())
		
		if target.is_in_group("Enemy"):
			target.health -= DAMAGE 
