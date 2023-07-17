extends CharacterBody3D

signal pause_game(is_paused)

const SPEED = 20.0
const JUMP_VELOCITY = 25
const ACCELERATION = 50.0
const DECCELERATION = 5.0

var mouse_sensitivity =  0.0198125 / 2  #Valorant 0.14 - factor de conversió a 1080p: 0.141517857142857

var count_down_started = false
var damage = 10
var shot_count = 0

var direction = Vector3()

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var bullet_hole = preload("res://scenes/ui/BulletHole.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	emit_signal("pause_game", false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func fire():
	if Input.is_action_just_pressed("fire"):
		if raycast.is_colliding():
			var target = raycast.get_collider()
			var bullet_hole_instance = bullet_hole.instantiate()
			
			target.add_child(bullet_hole_instance)
			bullet_hole_instance.global_transform.origin = raycast.get_collision_point()
			bullet_hole_instance.look_at(position + Vector3.FORWARD, raycast.get_collision_normal())
			
			if target.is_in_group("Enemy"):
				target.health -= damage 
		shot_count += 1
		if (!count_down_started):
			count_down_started = true

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	else:
		if event.is_action_pressed("ui_cancel"):
			emit_signal("pause_game", true)



func _physics_process(delta):
	fire()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= (gravity * 6) * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var thedirection = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if thedirection:
		# Check if the direction has changed.
		if thedirection.dot(velocity.normalized()) < 0:
			# Instantly stop the velocity.
			velocity = Vector3.ZERO
		else:
			# Add acceleration to the velocity.
			velocity += thedirection * ACCELERATION * delta
			# Limit the velocity to the maximum speed.
			if velocity.length() > SPEED:
				velocity = velocity.normalized() * SPEED
	else:
		# Decelerate the velocity.
		velocity -= velocity * DECCELERATION * delta

	move_and_slide()


