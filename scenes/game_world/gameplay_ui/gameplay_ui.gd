extends Node
class_name GameplayUI
## Gameplay UI with game stats

@onready var _animation_kill = $GameplayUI/AnimationKill
@onready var _score = $GameplayUI/MarginContainer/Panel/MarginContainer/VBoxContainer/score/label2
@onready var _timer_label = $GameplayUI/MarginContainer/Panel/MarginContainer/VBoxContainer/time/label2
@onready var _accuracy = $GameplayUI/MarginContainer/Panel/MarginContainer/VBoxContainer/accuracy/label2

## Feedback that tells the player to shoot to start the game
@export var _start_feedback: Node

var _timer: Timer

func initialize(new_timer: Timer, player: PlayerManager) -> void:
	_timer = new_timer
	player.shooted.connect(_on_player_shoot)

func target_destroyed(score: int, accuracy: float) -> void:
	update_score(score, accuracy)
	_animation_kill.play("RESET")
	_animation_kill.play("kill")

func update_score(score: int, accuracy: float) -> void:
	_score.set_text(str(score))
	_accuracy.set_text(str(snappedf(accuracy, 0.1)) + "%")

func update_timer_ui(time_left: float) -> void:
	_timer_label.set_text("%.f s" % time_left)

func _on_player_shoot() -> void:
	if _timer != null and _timer.is_stopped():
		_timer.start()
		_start_feedback.queue_free()
