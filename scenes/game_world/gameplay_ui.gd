extends Control
## Gameplay UI with game stats

@onready var _animation_kill = $AnimationKill
@onready var _kills = $MarginContainer/Panel/MarginContainer/VBoxContainer/targets/label2
@onready var _timer = $"../../Timer"
@onready var _timer_label = $MarginContainer/Panel/MarginContainer/VBoxContainer/time/label2

func update_kills(value: int) -> void:
	_kills.set_text((str(value)))
	if not _animation_kill.is_playing():
		_animation_kill.play("kill")

func update_timer_ui(time_left) -> void:
	_timer_label.set_text("%.f s" % time_left)

func _on_player_shoot() -> void:
	if _timer.is_stopped():
		_timer.start()
		$PressAny.queue_free()
