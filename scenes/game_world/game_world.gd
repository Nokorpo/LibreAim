extends Node3D

var packed_target = preload("res://scenes/enemies/target.tscn")
var location_target = Vector3()
var count_kills = 0
var id_spawn_target = 0

@onready var animation_kill = $CanvasLayer/GameplayUI/AnimationKill
@onready var kills = $CanvasLayer/GameplayUI/Panel/MarginContainer/VBoxContainer/targets/label2
@onready var captured_needed = $CanvasLayer/MouseCapturedRequested
@onready var timer = $Timer
@onready var timer_label = $CanvasLayer/GameplayUI/Panel/MarginContainer/VBoxContainer/time/label2

func _ready():
	timer.wait_time = Global.current_gamemode.time
	captured_needed.visible = false
	id_spawn_target = 0
	count_kills = 0
	
	for x in range(Global.current_gamemode.number_of_initial_targets):
		spawn_target()

func _process(_delta):
	if timer.is_stopped():
		update_timer_ui(timer.wait_time)
	else:
		update_timer_ui(timer.time_left)

func _on_mouse_captured_needed_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	captured_needed.visible = false

func _on_timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DataManager.save_high_score(Global.current_gamemode.id, count_kills)
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_player_shoot():
	if timer.is_stopped():
		timer.start()
		$CanvasLayer/GameplayUI/PressAny.queue_free()

func _on_target_destroyed():
	messageHit()
	spawn_target()

func randomize_vector():
	randomize()
	var location_x = randf_range(Global.current_gamemode.spawn_location_x_0, Global.current_gamemode.spawn_location_x_1)
	var location_y = randf_range(Global.current_gamemode.spawn_location_y_0, Global.current_gamemode.spawn_location_y_1)
	var location_z = -16
	return Vector3(location_x, location_y, location_z)

func spawn_target():
	id_spawn_target += 1
	var count_max = 0
	var vector_return = randomize_vector()
	location_target.x = vector_return.x
	location_target.y = vector_return.y
	location_target.z = vector_return.z
	
	var target = packed_target.instantiate()
	target.init(Global.current_gamemode.size, id_spawn_target, Global.current_gamemode.movment)
	target.connect("destroyed", Callable(self, "_on_target_destroyed"))
	target.set_position(location_target)
	add_child(target)
	
func messageHit():
	count_kills += 1
	kills.set_text((str(count_kills)))
	if not animation_kill.is_playing():
		animation_kill.play("kill")

func update_timer_ui(time_left):
	timer_label.set_text("%.f s" % time_left)
