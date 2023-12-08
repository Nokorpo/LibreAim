extends Node3D

func _ready():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0, 20)
	await tween.finished
	queue_free()
