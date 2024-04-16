extends Control
## Gameplay UI with game stats

@onready var _animation_kill = $AnimationKill
@onready var _score = $MarginContainer/Panel/MarginContainer/VBoxContainer/score/label2
@onready var _timer = $"../../Timer"
@onready var _timer_label = $MarginContainer/Panel/MarginContainer/VBoxContainer/time/label2
@onready var _accuracy = $MarginContainer/Panel/MarginContainer/VBoxContainer/accuracy/label2

func target_destroyed(score: int, accuracy: float) -> void:
	update_score(score, accuracy)
	_animation_kill.play("RESET")
	_animation_kill.play("kill")

func update_score(score: int, accuracy: float) -> void:
	_score.set_text(str(score))
	_accuracy.set_text(str(snappedf(accuracy, 1)) + "%")

func update_timer_ui(time_left: float) -> void:
	_timer_label.set_text("%.f s" % time_left)

func _on_player_shoot() -> void:
	if _timer.is_stopped():
		_timer.start()
		$PressAny.queue_free()
