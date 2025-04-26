@tool
@icon("res://scenes/game_world/scenario/scenario.svg")
class_name Scenario
extends Node3D
## A custom training scenario to be played

@warning_ignore("unused_signal")
signal target_destroyed
@warning_ignore("unused_signal")
signal target_missed
@warning_ignore("unused_signal")
signal target_hitted

@export var _light: DirectionalLight3D

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if _light == null:
		warnings.append("There should be a light node.")
	return warnings

func initialize() -> void:
	_update_world_appareance()

func _update_world_appareance() -> void:
	var world_material: StandardMaterial3D = preload("res://assets/material_default.tres")
	world_material.albedo_texture = Global.get_current_world_texture()
	_light.light_color = SaveManager.settings.get_data("world", "world_color")

func _on_target_destroyed() -> void:
	$".."._on_target_destroyed()

func _on_target_missed() -> void:
	$".."._on_target_missed()

func _on_target_hitted() -> void:
	$".."._on_target_hitted()
