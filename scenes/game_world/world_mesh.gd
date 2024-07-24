## Applied to world game world meshes to get the user defined texture
extends MeshInstance3D

func _ready() -> void:
	var world_material: StandardMaterial3D = preload("res://assets/material_default.tres")
	material_override = world_material
