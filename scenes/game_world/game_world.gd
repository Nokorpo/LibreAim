extends Node3D
## Manager of the game world during gameplay

## Number of targets destroyed by the player
var _targets_destroyed: int = 0
## Number of shots hitted by the player
var _hitted_shots: int = 0
## Number of shots missed by the player
var _missed_shots: int = 0

var _scenario: Scenario
@export var _timer: Timer
@export var _gameplay_ui: GameplayUI

func _ready() -> void:
	if Global.current_scenario:
		_timer.wait_time = Global.current_scenario.time
	_load_scenario()
	_scenario.target_destroyed.connect(_on_target_destroyed)
	_scenario.target_missed.connect(_on_target_missed)
	_scenario.target_hitted.connect(_on_target_hitted)
	$Player.connect("missed", Callable(self, "_on_target_missed"))
	_gameplay_ui.initialize(_timer, $Player)

func _process(_delta: float) -> void:
	if _timer.is_stopped():
		_gameplay_ui.update_timer_ui(_timer.wait_time)
	else:
		_gameplay_ui.update_timer_ui(_timer.time_left)

func _on_timer_timeout() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_timer.stop()
	var high_score := HighScoreManager.get_high_score(Global.current_scenario.id)
	HighScoreManager.save_high_score(Global.current_scenario.id, _get_score())
	$Player.queue_free()
	$PauseUI.queue_free()
	$EndGameUI.set_score(_get_score(), high_score, _get_accuracy())
	$GameplayUI.visible = false
	$EndGameUI.visible = true

func _on_target_destroyed() -> void:
	_play_destroyed_sound()
	_targets_destroyed += 1
	_gameplay_ui.target_destroyed(_get_score(), _get_accuracy())

func _on_target_missed() -> void:
	_missed_shots += 1
	_gameplay_ui.update_score(_get_score(), _get_accuracy())

func _on_target_hitted() -> void:
	_hitted_shots += 1
	_gameplay_ui.update_score(_get_score(), _get_accuracy())

func _play_destroyed_sound() -> void:
	var destroyed_sound: AudioStreamPlayer = $DestroyedSound
	destroyed_sound.pitch_scale = randf_range(0.95, 1.05)
	destroyed_sound.play()

func _get_score() -> int:
	if Global.current_scenario:
		var score = _hitted_shots * Global.current_scenario.score_per_hit
		if Global.current_scenario.accuracy_multiplier:
			score = score * (_get_accuracy() / 100)
		return score
	else:
		return _hitted_shots

func _get_accuracy() -> float:
	if _missed_shots == 0:
		return 100
	if _hitted_shots == 0:
		return 0
	return (float(_hitted_shots) / (float(_hitted_shots) + float(_missed_shots))) * 100

func _load_scenario() -> void:
	var scenario_resource = load(Global.current_scenario.path + "scenario.tscn")
	var new_scenario: Node = scenario_resource.instantiate()
	%LevelSpawner.add_child(new_scenario)
	new_scenario.initialize()
	_scenario = new_scenario
