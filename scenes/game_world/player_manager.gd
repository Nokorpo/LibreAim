extends CharacterBody3D

signal shoot

const SPEED = 5
const JUMP_STRENGTH = 8

var mouse_sensitivity = 0.001

var damage = 10

var movement_velocity: Vector3
var rotation_target: Vector3

var jump_single := true
var jump_double := true

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var bullet_hole = preload("res://scenes/game_world/bullet_hole.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	var user_sensitivity = 1
	var conversion_sensitivity = 0.04
	var category = DataManager.categories.SETTINGS
	
	if DataManager.get_data(category, "sensitivity_game_value"):
		conversion_sensitivity = DataManager.get_data(category, "sensitivity_game_value")
	if DataManager.get_data(category, "sensitivity"):
		user_sensitivity = DataManager.get_data(category, "sensitivity")
	if OS.has_feature("web"):
		mouse_sensitivity = user_sensitivity * conversion_sensitivity * 0.67857142857142857143
	else:
		mouse_sensitivity = user_sensitivity * conversion_sensitivity
	if DataManager.get_data(category, "camera_fov"):
		camera.fov = DataManager.get_data(category, "camera_fov")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if Input.is_action_just_pressed("shoot"):
		player_shoot()

func _physics_process(delta):
	# Handle functions
	handle_controls(delta)
	handle_gravity(delta)
	
	# Movement
	var applied_velocity: Vector3
	
	movement_velocity = transform.basis * movement_velocity # Move forward
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()

func handle_controls(_delta):
	# Movement
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	movement_velocity = Vector3(input.x, 0, input.y).normalized() * SPEED
	
	# Jumping
	if Input.is_action_just_pressed("jump"):
		
		if jump_double:
			gravity = -JUMP_STRENGTH
			jump_double = false
			
		if jump_single: 
			action_jump()

# Handle gravity
func handle_gravity(delta):
	gravity += 20 * delta
	
	if gravity > 0 and is_on_floor():
		jump_single = true
		gravity = 0

# Jumping
func action_jump():
	gravity = -JUMP_STRENGTH
	
	jump_single = false;
	jump_double = true;

# Shooting
func player_shoot():
	shoot.emit()
	if raycast.is_colliding():
		var target = raycast.get_collider()
		var bullet_hole_instance = bullet_hole.instantiate()
		
		target.add_child(bullet_hole_instance)
		bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
		bullet_hole_instance.look_at(position + Vector3.FORWARD, raycast.get_collision_normal())
		
		if target.is_in_group("Enemy"):
			target.health -= damage 
