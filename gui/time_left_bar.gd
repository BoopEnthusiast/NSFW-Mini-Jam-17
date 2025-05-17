class_name TimeLeft
extends Label


func _process(_delta: float) -> void:
	text = "%d" % Nodes.main.time_left
