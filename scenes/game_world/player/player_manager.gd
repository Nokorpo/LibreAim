extends CharacterBody3D
## First person character controller

signal shooted ## When player shoots
signal missed ## When player mises a shot

const SHOOT_COOLDOWN: float = 0.1
const SPEED: int = 5
const JUMP_FORCE: int = 8
const MAX_CAMERA_ANGLE: int = 89 ## Max vertical angle of the camera

var mouse_sensitivity: float = 0.01

var jumps: Array[bool] = [true, true]
var gravity: float = 0.0
var current_shoot_cooldown: float

@onready var camera = $Head/Camera3D
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var bullet_hole = preload("res://scenes/game_world/bullet_hole.tscn")

func _ready() -> void:
	camera.fov = DataManager.get_data("settings", "video", "fov")
	mouse_sensitivity = _get_mouse_sensitivity()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-MAX_CAMERA_ANGLE), deg_to_rad(MAX_CAMERA_ANGLE))
	if Global.current_gamemode and Global.current_gamemode.health == 0:
		if event.is_action_pressed("shoot"):
			_shoot(1)
	if event.is_action_pressed("jump") \
		and ((Global.current_gamemode and Global.current_gamemode.player_movement) \
		or Global.current_gamemode.is_empty()):
		_jump()

func _process(delta: float) -> void:
	if Global.current_gamemode and Global.current_gamemode.health > 0:
		current_shoot_cooldown += delta
		if current_shoot_cooldown > SHOOT_COOLDOWN:
			if Input.is_action_pressed("shoot"):
				_shoot(SHOOT_COOLDOWN)
				current_shoot_cooldown = 0
	
	_handle_joypad_rotation(delta)

func _physics_process(delta: float) -> void:
	if (Global.current_gamemode and Global.current_gamemode.player_movement) or Global.current_gamemode.is_empty():
		_handle_gravity(delta)
		var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var movement_velocity := Vector3(input.x, 0, input.y) * SPEED
		movement_velocity = transform.basis * movement_velocity
		
		var applied_velocity := velocity.lerp(movement_velocity, delta * 10)
		applied_velocity.y = -gravity
		
		velocity = applied_velocity
		move_and_slide()

func _get_mouse_sensitivity() -> float:
	var user_sensitivity: float = DataManager.get_data("settings", "user", "sensitivity")
	var conversion_sensitivity: float = DataManager.get_data("settings", "user", "sensitivity_game_value")
	return user_sensitivity * conversion_sensitivity

func _handle_joypad_rotation(delta: float) -> void:
	var joypad_dir: Vector2 = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if joypad_dir.length() > 0:
		rotate_y(deg_to_rad(-joypad_dir.x * mouse_sensitivity * delta * 1000))
		camera.rotate_x(deg_to_rad(-joypad_dir.y * mouse_sensitivity * delta * 1000))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-MAX_CAMERA_ANGLE), deg_to_rad(MAX_CAMERA_ANGLE))

func _handle_gravity(delta: float) -> void:
	gravity += 20 * delta
	if gravity > 0 and is_on_floor():
		for i in range(jumps.size()):
			jumps[i] = true
		gravity = 0

func _jump() -> void:
	for i in range(jumps.size()):
		if jumps[i]:
			jumps[i] = false
			gravity = -JUMP_FORCE
			return

func _shoot(damage: float) -> void:
	shooted.emit()
	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target != null:
			var bullet_hole_instance = bullet_hole.instantiate()
			
			target.add_child(bullet_hole_instance)
			bullet_hole_instance.global_transform.origin = raycast.get_collision_point() + raycast.get_collision_normal() * 0.001
			bullet_hole_instance.look_at(bullet_hole_instance.global_position + raycast.get_collision_normal(), Vector3.FORWARD )
			
			if target.is_in_group("Enemy"):
				target.health -= damage
			else:
				emit_signal("missed")
