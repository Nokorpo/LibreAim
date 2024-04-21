extends Sprite3D
## Slider that shows the health of the enemy targets

var enabled: bool = false

func _process(_delta: float) -> void:
	visible = enabled
	if enabled:
		var health = $"..".health
		var max_health = $"..".max_health
		$HealthSliderViewport/ProgressBar.value = (health / max_health) * 100

func enable() -> void:
	enabled = true
	position.y = ($"../CollisionShape3D/MeshInstance3D".mesh.height / 2) + 0.4
	$ColorAnimationPlayer.play("RESET")

func _on_target_hitted() -> void:
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.pitch_scale = randf_range(0.97, 1.03)
	$ColorAnimationPlayer.play("change_color")
	
