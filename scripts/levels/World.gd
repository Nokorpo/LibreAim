extends Node3D

var packed_target = preload("res://scenes/characters/target.tscn")
var location_target = Vector3()
var count_kills = 0
var id_spawn_target = 0

#Game parameters
var spawn_location_x_0 = 12
var spawn_location_x_1 = -12
var spawn_location_y_0 = 4
var spawn_location_y_1 = 20
var number_of_initial_targets = 1
var size = 0.5
var movment = false

#@onready var anim_hit = $FPS/Head/Camera3D/AnimationHit

# Called when the node enters the scene tree for the first time.
func _ready():
	id_spawn_target = 0
	count_kills = 0
	var id_game = Global.game_type
	if(id_game == "3d_head_level_v1"):
		spawn_location_x_0 = 24
		spawn_location_x_1 = -24
		spawn_location_y_0 = 4
		spawn_location_y_1 = 4
		movment = false
		size = 0.5
		number_of_initial_targets = 1
	elif(id_game == "3d_multiple_basic_targets_movement_v1"):
		spawn_location_x_0 = 12
		spawn_location_x_1 = -12
		spawn_location_y_0 = 4
		spawn_location_y_1 = 20
		movment = true
		size = 0.5
		number_of_initial_targets = 6
	elif(id_game == "3d_multiple_basic_targets_v1"):
		spawn_location_x_0 = 12
		spawn_location_x_1 = -12
		spawn_location_y_0 = 4
		spawn_location_y_1 = 20
		movment = false
		size = 0.5
		number_of_initial_targets = 6
	elif(id_game == "3d_multiple_medium_targets_v1"):
		spawn_location_x_0 = 11
		spawn_location_x_1 = -11
		spawn_location_y_0 = 4
		spawn_location_y_1 = 15
		movment = false
		size = 3
		number_of_initial_targets = 3
	else:
		spawn_location_x_0 = 12
		spawn_location_x_1 = -12
		spawn_location_y_0 = 4
		spawn_location_y_1 = 20
		movment = false
		size = 0.5
		number_of_initial_targets = 1
	
	for x in range(number_of_initial_targets):
		spawn_target()

func target_killed():
	messageHit()
	spawn_target()

func randomize_vector():
	randomize()
	var location_x = randf_range(spawn_location_x_0, spawn_location_x_1)
	var location_y = randf_range(spawn_location_y_0, spawn_location_y_1)
	var location_z = -25
	return Vector3(location_x, location_y, location_z)

func check_distance():
	var vector_return = randomize_vector()
	var distance = 0
	var have_distance = true
	#if (DataManager.last_vectors.keys().size() > 0):
	#	for last_key in DataManager.last_vectors.keys():
	#		distance = DataManager.last_vectors[last_key].distance_to(vector_return)
	#		if(distance < (size * 2)):
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
	target.init(size, id_spawn_target, movment)
	target.connect("target_kill", Callable(self, "target_killed"))
	target.set_position(location_target)
	add_child(target)
	
func messageHit():
	count_kills += 1
	#$FPS/Head/Camera3D/LeftVBoxContainer/Kills.set_text((str(count_kills)))
	#if not anim_hit.is_playing():
	#	anim_hit.play("animationHit")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_menu_pressed():
	pass # Replace with function body.
