class_name TimeLeft
extends Label


func _process(_delta: float) -> void:
	text = "%.2f" % Nodes.main.time_left
