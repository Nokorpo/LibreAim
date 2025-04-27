class_name HealthSlider
extends MeshInstance3D
## Slider that shows the health of the enemy targets

func _ready() -> void:
	var new_mesh: Mesh = get_mesh().duplicate()
	set_mesh(new_mesh)
	var new_material: Material = get_mesh().get_material().duplicate()
	get_mesh().set_material(new_material)

func _process(_delta: float) -> void:
	var health = $"..".health
	var max_health = $"..".max_health
	scale.x = lerp(0, 10, health / max_health)

func _on_target_hitted() -> void:
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.pitch_scale = randf_range(0.97, 1.03)
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("shot")
