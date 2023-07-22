extends Control
@onready var crosshair = $ScrollContainer/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/Crosshair

# Called when the node enters the scene tree for the first time.
func _ready():
	print(crosshair.is_pressed())
	crosshair.set_pressed(true)
	var all_put_labels = get_tree().get_nodes_in_group("PutLabel")
	for put_label in all_put_labels:
		putLabel(put_label)

func putLabel(put_label):
	var label = Label.new()
	var hbox = HBoxContainer.new()
	label.text = put_label.name + ': '
	hbox.add_child(label)
	var parent = put_label.get_parent()
	var index = put_label.get_index()
	parent.remove_child(put_label)
	hbox.add_child(put_label)
	parent.add_child(hbox)
	parent.move_child(hbox, index)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/MainScreen.tscn")
