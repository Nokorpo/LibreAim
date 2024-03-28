extends Control
## Gameplay UI with game stats

@onready var animation_kill = $AnimationKill
@onready var kills = $MarginContainer/Panel/MarginContainer/VBoxContainer/targets/label2
@onready var timer = $"../../Timer"
@onready var timer_label = $MarginContainer/Panel/MarginContainer/VBoxContainer/time/label2

func update_kills(value: int) -> void:
	kills.set_text((str(value)))
	if not animation_kill.is_playing():
		animation_kill.play("kill")

func update_timer_ui(time_left) -> void:
	timer_label.set_text("%.f s" % time_left)

func _on_player_shoot() -> void:
	if timer.is_stopped():
		timer.start()
		$PressAny.queue_free()
