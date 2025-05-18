class_name FemBaseModel
extends Node3D


@export var nude: bool = false

var which_mesh: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var meshes = [$"Fem Rig/Skeleton3D/Fem 1", $"Fem Rig/Skeleton3D/Fem 2", $"Fem Rig/Skeleton3D/Fem 3"]
var nude_meshes = [$"Fem Rig/Skeleton3D/Fem 1 Nude", $"Fem Rig/Skeleton3D/Fem 2 Nude", $"Fem Rig/Skeleton3D/Fem 3 Nude"]


func _ready() -> void:
	which_mesh = randi_range(0, 2)
	
	for mesh in meshes:
		mesh.visible = false
	for mesh in nude_meshes:
		mesh.visible = false
	
	if nude:
		nude_meshes[which_mesh].visible = true
	else:
		meshes[which_mesh].visible = true
