extends Node3D

var packed_target = preload("res://scenes/characters/target.tscn")
var location_target = Vector3()
var count_kills = 0
var id_spawn_target = 0


@onready var animation_kill = $Player/Head/AnimationKill
@onready var kill = $Player/Head/Kill
@onready var kills = $Player/Head/Kills
@onready var full_screen_needed = $CanvasLayer/FullScreenRequest
@onready var captured_needed = $CanvasLayer/MouseCapturedRequested
#@onready var anim_hit = $FPS/Head/Camera3D/AnimationHit

# Called when the node enters the scene tree for the first time.
func _ready():
	full_screen_needed.visible = false
	captured_needed.visible = false
	full_screen_requested()
	id_spawn_target = 0
	count_kills = 0
	
	kill.visible = false
	
	for x in range(Global.game_type.number_of_initial_targets):
		spawn_target()

func _process(_delta):
	full_screen_requested()


func target_killed():
	messageHit()
	spawn_target()

func randomize_vector():
	randomize()
	var location_x = randf_range(Global.game_type.spawn_location_x_0, Global.game_type.spawn_location_x_1)
	var location_y = randf_range(Global.game_type.spawn_location_y_0, Global.game_type.spawn_location_y_1)
	var location_z = -25
	return Vector3(location_x, location_y, location_z)

func check_distance():
	var vector_return = randomize_vector()
	var distance = 0
	var have_distance = true
	#if (DataManager.last_vectors.keys().size() > 0):
	#	for last_key in DataManager.last_vectors.keys():
	#		distance = DataManager.last_vectors[last_key].distance_to(vector_return)
	#		if(distance < (Global.game_type.size * 2)):
	#			have_distance = false
	return [have_distance, vector_return, distance]

func spawn_target():
	id_spawn_target += 1
	var return_distance_array = check_distance()
	var count_max = 0
	while return_distance_array[0] != true and count_max < 100:
		count_max += 1
		return_distance_array = check_distance()
	var vector_return = return_distance_array[1]
	location_target.x = vector_return.x
	location_target.y = vector_return.y
	location_target.z = vector_return.z
	
	#DataManager.last_vectors[id_spawn_target] = vector_return
	
	var target = packed_target.instantiate()
	target.init(Global.game_type.size, id_spawn_target, Global.game_type.movment)
	target.connect("target_kill", Callable(self, "target_killed"))
	target.set_position(location_target)
	add_child(target)
	
func messageHit():
	count_kills += 1
	kills.set_text((str(count_kills)))
	if not animation_kill.is_playing():
		animation_kill.play("kill")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	if Input.is_action_pressed("f_pressed"):
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		is_already_full_screen()

func _on_menu_pressed():
	pass # Replace with function body.

func full_screen_requested():
	if (DisplayServer.window_get_mode() < 3):
		full_screen_needed.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true



func _on_full_screen_needed_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	full_screen_needed.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	captured_needed.visible = true
	var timer = Timer.new()
	timer.set_wait_time(3)
	timer.connect("timeout", Callable(self, "full_screen_requested"))


func _on_mouse_captured_needed_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	captured_needed.visible = false
