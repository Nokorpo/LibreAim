extends MeshInstance3D
## Slider that shows the health of the enemy targets

var enabled: bool = false

func _process(_delta: float) -> void:
	visible = enabled
	if enabled:
		var health = $"..".health
		var max_health = $"..".max_health
		mesh.size.x = lerp(0, 3, health / max_health)

func enable() -> void:
	visible = true
	enabled = true
	position.y = ($"../CollisionShape3D/MeshInstance3D".mesh.height / 2) + 0.4

func _on_target_hitted() -> void:
	if enabled:
		$AudioStreamPlayer.play()
		$AudioStreamPlayer.pitch_scale = randf_range(0.97, 1.03)
		$AnimationPlayer.play("RESET")
		$AnimationPlayer.play("shot")
