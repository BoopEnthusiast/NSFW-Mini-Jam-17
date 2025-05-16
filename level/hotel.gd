class_name Hotel
extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.entered_hotel()


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		body.exited_hotel()
