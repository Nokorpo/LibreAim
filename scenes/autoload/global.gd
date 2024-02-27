extends Node

const gamemodes: Dictionary = {
	"random": {
		"id": "random",
		"title": "Random targets",
		"description": "Random static targets.",
		"spawn_location": {
			"x": [-5, 5],
			"y": [1, 9]
		},
		"time": 30,
		"movement": false,
		"size": 2,
		"initial_targets": 3
	},
	"horizontal": {
		"id": "horizontal",
		"title": "Horizontal targets",
		"description": "All targets spawn at the same height.",
		"spawn_location": {
			"x": [-15, 15],
			"y": [5, 5]
		},
		"time": 30,
		"movement": false,
		"size": 1,
		"initial_targets": 1
	},
	"moving": {
		"id": "moving",
		"title": "Moving targets",
		"description": "Targets move in random patterns.",
		"spawn_location": {
			"x": [-15, 15],
			"y": [1, 9]
		},
		"time": 30,
		"movement": true,
		"size": 2,
		"initial_targets": 6
	}
}

var current_gamemode : Dictionary

func string_to_vector3d(string_vector: String) -> Vector3:
	var components_str = string_vector.substr(1, string_vector.length() - 2)
	var components = components_str.split(",")

	# Convert each component from string to float
	var x = components[0].to_float()
	var y = components[1].to_float()
	var z = components[2].to_float()

	# Create the Vector3D object
	return Vector3(x, y, z)

func string_to_color(string_vector: String) -> Color:
	var components_str = string_vector.substr(1, string_vector.length() - 2)
	var components = components_str.split(",")

	# Convert each component from string to float
	var r = components[0].to_float()
	var g = components[1].to_float()
	var b = components[2].to_float()
	var a = components[3].to_float()

	# Create the Vector3D object
	return Color(r, g, b, a)
