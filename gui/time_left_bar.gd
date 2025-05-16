class_name TimeLeftBar
extends ProgressBar


func _process(_delta: float) -> void:
	if Nodes.main.time_left > max_value:
		max_value = Nodes.main.time_left
	value = Nodes.main.time_left
