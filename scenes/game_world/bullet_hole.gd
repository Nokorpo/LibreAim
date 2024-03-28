extends Node3D
## Bullet hole decals when user shoots

func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0, 20)
	await tween.finished
	queue_free()
