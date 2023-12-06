extends Control
## Gameplay UI with game stats

@onready var animation_kill = $AnimationKill
@onready var kills = $Panel/MarginContainer/VBoxContainer/targets/label2
@onready var timer = $"../../Timer"
@onready var timer_label = $Panel/MarginContainer/VBoxContainer/time/label2

func update_kills(value: int):
	kills.set_text((str(value)))
	if not animation_kill.is_playing():
		animation_kill.play("kill")

func update_timer_ui(time_left):
	timer_label.set_text("%.f s" % time_left)
